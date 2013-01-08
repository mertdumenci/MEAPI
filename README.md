# MEAPI
*Objective-C Handler for http://my.eyuboglu.com*

***

My old school, Eyuboglu has an online students portal which you can go in and check your latest marks, read the latest news of the school and such.

They also have an iPhone app, which I hated using. It's an user experience wreck. I couldn't do anything for it back then, I simply wasn't able to.


**Now I present MEAPI, an Objective-C handler for the portal, using the reverse engineered API endpoints.**

I spent a lot of time figuring out how the API authenticated, but yeah here it is.

It uses AFNetworking, OpenUDID and UICKeychainStore — added as submodules. (git submodule update --init)

The code documents itself, the method names are straightforward.
But here is an example anyway : 
```objective-c
        [[MEAPI sharedInstance] getSessionTokenWithCompletionBlock:^(NSString *sessionToken) {
            NSLog(@"Got session token, this will be stored for this usage session, no need for calling it again and again for every API call.");
            
            NSString *schoolNumber = @"";
            NSString *password = @"";
            NSString *schoolCode = @"";
            
            [[MEAPI sharedInstance] loginWithSchoolNumber:schoolNumber password:password schoolCode:schoolCode withCompletionBlock:^(MEStudent *student, NSError *error) {
                NSLog(@"Logged in student %@", student);
                
                [[MEAPI sharedInstance] getCurrentCardWithType:MEAPICardTypeUpToDate completionBlock:^(MECard *card, NSError *error) {
                    NSLog(@"We got the card! %@", card.image);
                }];
            }];
        }];;
```
