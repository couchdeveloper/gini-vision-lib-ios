//
//  OnboardingStrings.swift
//  GiniVision
//
//  Created by Enrique del Pozo Gómez on 7/31/18.
//

import Foundation

enum OnboardingStrings: LocalizableStringResource {
    
    case onboardingFirstPageText, onboardingSecondPageText, onboardingThirdPageText, onboardingFourthPageText,
    onboardingFifthPageText
    
    var tableName: String {
        return "onboarding"
    }
    
    var tableEntry: LocalizationEntry {
        switch self {
        case .onboardingFirstPageText:
            return ("firstPage", "Text on the first page of the onboarding screen")
        case .onboardingSecondPageText:
            return ("secondPage", "Text on the second page of the onboarding screen")
        case .onboardingThirdPageText:
            return ("thirdPage", "Text on the third page of the onboarding screen")
        case .onboardingFourthPageText:
            return ("fourthPage", "Text on the fouth page of the onboarding screen")
        case .onboardingFifthPageText:
            return ("fifthPage", "Text on the fifth page of the onboarding screen")
        }
    }
    
    var customizable: Bool {
        return true
    }
    
    var args: CVarArg? {
        return nil
    }
    
}
