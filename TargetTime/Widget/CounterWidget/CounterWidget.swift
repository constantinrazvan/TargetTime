//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Constantin Razvan on 03.11.2021.
//  Copyright © 2021 meech-ward. All rights reserved.
//

import WidgetKit
import SwiftUI
import TodoList

struct Provider: IntentTimelineProvider {

}

struct SimpleEntry: TimelineEntry {
    let tasks = ViewController()
    let configuration: ConfigurationIntent
}

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            Color(.systemGreen)
            .ignoresSafeArea()
        VStack{
            Text("Completed Tasks")
                .fontWeight(.heavy)
                .font(.system(size: 15))
                .foregroundColor(.white)
            Text("1")
                .fontWeight(.heavy)
                .font(.system(size: 40))
                .foregroundColor(.white)
            }
        }
    }
}

@main
struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CounterWidget_Previews: PreviewProvider {
    static var previews: some View {
        CounterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
