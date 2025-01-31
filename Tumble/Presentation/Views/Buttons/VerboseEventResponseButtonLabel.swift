//
//  VerboseEventResponseButtonLabel.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-17.
//

import SwiftUI

struct VerboseEventResponseButtonLabel: View {
    let event: Response.Event
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.course.englishName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.onSurface)
                    Text(event.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.system(size: 15))
                        .foregroundColor(.onSurface.opacity(0.7))
                }
                HStack {
                    Image(systemName: "person.3.sequence")
                        .font(.system(size: 15))
                        .foregroundColor(.onSurface.opacity(0.7))
                    if let teacher = event.teachers.first {
                        if !teacher.firstName.isEmpty && !teacher.lastName.isEmpty {
                            Text("\(teacher.firstName) \(teacher.lastName)")
                                .font(.system(size: 15))
                                .foregroundColor(.onSurface.opacity(0.7))
                        } else {
                            Text(NSLocalizedString("No teachers listed", comment: ""))
                                .font(.system(size: 15))
                                .foregroundColor(.onSurface.opacity(0.7))
                        }
                    } else {
                        Text(NSLocalizedString("No teachers listed", comment: ""))
                            .font(.system(size: 15))
                            .foregroundColor(.onSurface.opacity(0.7))
                    }
                }
                HStack {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 15))
                            .foregroundColor(.onSurface)
                        Text(event.locations.first?.id.capitalized ?? NSLocalizedString("Unknown", comment: ""))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.onSurface)
                    }
                    Spacer()
                    if let timeFrom = event.from.convertToHoursAndMinutesISOString(),
                       let timeTo = event.to.convertToHoursAndMinutesISOString()
                    {
                        HStack {
                            Circle()
                                .foregroundColor(event.isSpecial ? Color.red : color)
                                .frame(width: 7, height: 7)
                            Text("\(timeFrom) - \(timeTo)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.onSurface)
                        }
                    }
                }
            }
            .padding()
            .frame(height: 160, alignment: .leading)
            .frame(maxWidth: .infinity)
            .background(event.isSpecial ? Color.red.opacity(0.2) : Color.surface)
            .background(Color.surface)
            .cornerRadius(15)
        }
    }
}
