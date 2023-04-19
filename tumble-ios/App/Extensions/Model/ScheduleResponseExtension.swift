//
//  ScheduleExtensions.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/18/22.
//

import Foundation
import SwiftUI
import RealmSwift
import Realm


extension [Response.Schedule] {
    
    func flatten() -> [Response.Day] {
        var days = [Response.Day]()
            for schedule in self {
                days += schedule.days
            }
        return days
    }
        
    func removeDuplicateEvents() -> [Response.Schedule] {
        var eventIds = Set<String>()
        return self.map { schedule in
            let uniqueDays = schedule.days.map { day in
                let uniqueEvents = day.events.filter { event in
                    eventIds.insert(event.id).inserted
                }
                return Response.Day(
                    name: day.name,
                    date: day.date,
                    isoString: day.isoString,
                    weekNumber: day.weekNumber,
                    events: uniqueEvents
                )
            }
            return Response.Schedule(id: schedule.id, cachedAt: schedule.cachedAt, days: uniqueDays)
        }
    }
}

extension Response.Schedule {
    
    func toRealmSchedule(scheduleRequiresAuth: Bool, schoolId: String, existingCourseColors: [String : String] = [:]) -> Schedule {
        let realmDays = RealmSwift.List<Day>()
        var colors = Set(colors)
        var visitedColors: [String: String] = existingCourseColors
        for responseDay in self.days {
            let realmEvents = RealmSwift.List<Event>()
            for responseEvent in responseDay.events {
                let courseId = responseEvent.course.id
                if visitedColors[courseId] == nil {
                    visitedColors[courseId] = colors.popFirst()
                }
                let course = Course(
                    courseId: responseEvent.course.id,
                    swedishName: responseEvent.course.swedishName,
                    englishName: responseEvent.course.englishName,
                    color: visitedColors[courseId] ?? "#FFFFFF")
                let locations = RealmSwift.List<Location>()
                for responseLocation in responseEvent.locations {
                    let location = Location(locationId: responseLocation.id, name: responseLocation.name, building: responseLocation.building, floor: responseLocation.floor, maxSeats: responseLocation.maxSeats)
                    locations.append(location)
                }
                let teachers = RealmSwift.List<Teacher>()
                for responseTeacher in responseEvent.teachers {
                    let teacher = Teacher(teacherId: responseTeacher.id, firstName: responseTeacher.firstName, lastName: responseTeacher.lastName)
                    teachers.append(teacher)
                }
                let event = Event(eventId: responseEvent.id, title: responseEvent.title, course: course, from: responseEvent.from, to: responseEvent.to, locations: locations, teachers: teachers, isSpecial: responseEvent.isSpecial, lastModified: responseEvent.lastModified)
                realmEvents.append(event)
            }
            let realmDay = Day(name: responseDay.name, date: responseDay.date, isoString: responseDay.isoString, weekNumber: responseDay.weekNumber, events: realmEvents)
            realmDays.append(realmDay)
        }
        let realmSchedule = Schedule(
            scheduleId: self.id,
            cachedAt: self.cachedAt,
            days: realmDays,
            schoolId: schoolId,
            requiresAuth: scheduleRequiresAuth
        )
        return realmSchedule
    }



    
    func isScheduleEmpty() -> Bool {
        for day in self.days {
            for event in day.events {
                if !event.title.isEmpty {
                    return false
                }
            }
        }
        return true
    }

    
    // Returns dictionary of random colors for each course in a schedule
    func assignCoursesRandomColors() -> [String : String] {
        var courseColors: [String : String] = [:]
        var availableColors = Set(colors)
        for day in self.days {
            for event in day.events {
                if courseColors[event.course.id] == nil {
                    if let hexColorString = availableColors.popFirst() {
                        courseColors[event.course.id] = hexColorString
                    }
                }
            }
        }
        return courseColors
    }
    
    func flatten() -> [Response.Day] {
        return self.days.reduce(into: []) {
            if $1.isValidDay() {$0.append($1)}}
    }

    
    func courses() -> [String] {
        return Array(Set(self.days.flatMap { $0.events.map { $0.course.id } }))
    }
    
    func isEmpty() -> Bool {
        return days.allSatisfy { $0.events.isEmpty }
    }


}
