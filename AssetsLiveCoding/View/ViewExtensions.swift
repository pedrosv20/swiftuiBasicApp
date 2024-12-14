import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: ((Self) -> Content)) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<IFContent: View, ElseContent: View>(
        _ condition: Bool,
        transform: ((Self) -> IFContent),
        elseTransform: ((Self) -> ElseContent)
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Conditional modifier for `if`, `else if`, and `else`.
       @ViewBuilder
       func `if`<FirstContent: View, SecondContent: View, ElseContent: View>(
           _ firstCondition: Bool,
           transform: ((Self) -> FirstContent),
           elseIfCondition: Bool,
           elseIfTransform: ((Self) -> SecondContent),
           elseTransform: ((Self) -> ElseContent)
       ) -> some View {
           if firstCondition {
               transform(self)
           } else if elseIfCondition {
               elseIfTransform(self)
           } else {
               elseTransform(self)
           }
       }
}
