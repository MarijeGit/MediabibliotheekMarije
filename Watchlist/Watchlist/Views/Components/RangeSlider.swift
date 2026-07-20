// RangeSlider.swift
// Custom slider voor een bereik (bijv. duur in minuten).

import SwiftUI

struct RangeSlider: View {
    @Binding var value: ClosedRange<Int>
    var in: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Slider(value: $value.lowerBound, in: in)
                .tint(.blue)
            Slider(value: $value.upperBound, in: in)
                .tint(.blue)
        }
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        @State var range = 0...300
        RangeSlider(value: $range, in: 0...300)
    }
}
