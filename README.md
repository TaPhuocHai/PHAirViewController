# PHAirViewController

* A UIViewController subclass for create menu in iOS app like Airbnb app.
* Support storyboard.

## Examples

[![YouTube video](http://img.youtube.com/vi/JDL7HxkFFic/hqdefault.jpg)](http://www.youtube.com/watch?v=JDL7HxkFFic)

[YouTube](http://www.youtube.com/watch?v=JDL7HxkFFic)

## Requirements

* iOS 5.0 through iOS 7.0 or later.
* ARC memory management.

## Usage
 
#### Code
* See Demo2 project
* Create PHMenuViewController subclass from PHAirViewController, init PHMenuViewController with code :

        - (id)initWithRootViewController:(UIViewController*)viewController
                     atIndexPath:(NSIndexPath*)indexPath
* Implement `PHAirMenuDelegate` and `PHAirMenuDataSource`       
* To show menu, call function:

        [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];               
        
* On my view controller, for swipe to show menu, in `viewDidLoad` :

        - (void)viewDidLoad
        {
          [super viewDidLoad];
          .....
    
          typeof(self) bself = self;
          self.phSwipeHander = ^{
               [bself.airViewController showAirViewFromViewController:bself.navigationController complete:nil];
          };
        }     

#### Storyboard
* See PHAirViewController project
* In storyboard, set `PHAirViewController` or subclass of `PHAirViewController` as initial View Controller
* Set root view controller for instance of `PHAirViewcontroller` by set segue class `PHAirViewControllerSegue` and segue identifier `phair_root`
* When using function `- (NSString*)segueForRowAtIndexPath:(NSIndexPath*)indexPath`, in storyboard, set segue with segue class `PHAirViewControllerSegue`


## License

Copyright (c) 2014 Phuoc Hai <taphuochai@gmail.com>

PHAirViewController is licensed under MIT License Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software
