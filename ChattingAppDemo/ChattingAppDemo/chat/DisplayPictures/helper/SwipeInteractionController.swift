

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
  
    var interactionInProgress = false {
        didSet {
            if !interactionInProgress {
                previousLocation = nil
            }
        }
    }
    
//  var parentSnapshot: UIView?
  private var previousLocation:CGFloat?
  private var shouldCompleteTransition = false
    
  private weak var viewController: UIViewController!
  
    init(viewController: UIViewController) {
    super.init()
    self.viewController = viewController

  }
  
}

extension CGFloat {
    var absolute:CGFloat {
        get {
            return self * (self > 0 ? 1 : -1)
        }
    }
    
}
