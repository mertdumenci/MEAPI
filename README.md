# MEAPI

MEAPI is an Objective-C wrapper for [My Eyuboglu](http://my.eyuboglu.com), using the reverse engineered API endpoints.
[My Eyuboglu](http://my.eyuboglu.com) is the school portal for Eyuboglu, my former school. I hated their app, so...

## Usage

MEAPI utilizes the singleton pattern.

**Initialization**

```objective-c
+(instancetype)sharedInstance;

[MEAPI sharedInstance]
        // Returns a MEAPI instance
```

**Obtaining session token**

A session token must be existent for the following methods to work.

```objective-c
-(void)getSessionTokenWithCompletionBlock:(MEAPISessionTokenCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getSessionTokenWithCompletionBlock:^(NSString *sessionToken) {
        /*
                sessionToken:
                        @"abcdefghijklm"
                
                Session token is stored automatically, the completion block is provided for convenience.
        */
}];
```

**Fetch newest school news**

```objective-c
-(void)getNewsWithCompletionBlock:(MEAPINewsCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getNewsWithCompletionBlock:^(NSArray *news, NSError *error) {
        /*
                news:
                        MENews
                        MENews
                        MENews
                        ...
                        
                error:
                        Generic NSError object filled up if an error occurs.
        */
}];
```

**Fetch school names list**

```objective-c
-(void)getSchoolListWithCompletionBlock:(MEAPISchoolListCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getSchoolListWithCompletionBlock:^(NSArray *schools, NSError *error) {
        /*
                schools:
                        MESchool
                        MESchool
                        MESchool
                        ...
                        
                error:
                        Generic NSError object filled up if an error occurs.
        */
}];
```

**Fetching detail for a news object**

```objective-c
-(void)getDetailForNews:(MENews *)news completionBlock:(MEAPINewsDetailCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getDetailForNews:(MENews *)news
                        completionBlock:^(MENews *news, NSError *error) {
        /*
                news:
                        The news object provided to the method, filled up with additional information. Check MENews.h.
                        
                error:
                        Generic NSError object filled up if an error occurs.
        */
}];
```

**Auto login with saved credentials**

```objective-c
-(void)autologinWithCompletionBlock:(MEAPIAutoLoginCompletionBlock)completionBlock;

[[MEAPI sharedInstance] autologinWithCompletionBlock:^(MEStudent *student, NSError *error) {
        /*
                student:
                        Logged in student.
                        
                error:
                        Generic NSError object filled up if an error occurs.
        */
}];
```

**Login with credentials**

```objective-c
-(void)loginWithSchoolNumber:(NSString *)schoolNumber password:(NSString *)password schoolCode:(NSString *)schoolCode withCompletionBlock:(MEAPILoginCompletionBlock)completionBlock;

[[MEAPI sharedInstance] loginWithSchoolNumber:@"100"
                        password:@"dummy"
                        schoolCode:@"dummy"
                        withCompletionBlock:^(MEStudent *student, NSError *error) {
                                 /*
                                        student:
                                                Logged in student.
                        
                                        error:
                                                Generic NSError object filled up if an error occurs.
                                                
                                        Credentials are saved upon login. Check -autologinWithCompletionBlock:
                                */
}];
```

**Logout**

```objective-c
-(void)logout;

[[MEAPI sharedInstance] logout];

/* 
        Clears the session token & resets saved credentials 
*/
```

**Get card**

```objective-c
-(void)getCurrentCardWithType:(MEAPICardType)type completionBlock:(MEAPICardCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getCurrentCardWithType:MEAPICardTypeOfficial
                        completionBlock:^(MECard *card, NSError *error) {
                                 /*
                                        card:
                                                Fetched card.
                        
                                        error:
                                                Generic NSError object filled up if an error occurs.
                                */
}];
```

**Fetching detail for a news object**

```objective-c
-(void)getAndAppendAdditionalInfoToStudent:(MEStudent *)student completionBlock:(MEAPIAdditionalStudentInfoCompletionBlock)completionBlock;

[[MEAPI sharedInstance] getAndAppendAdditionalInfoToStudent:(MEStudent *)student
                        completionBlock:^(MEStudent *student, NSError *error) {
        /*
                student:
                        The student object provided to the method, filled up with additional information. Check MEStudent.h.
                        
                error:
                        Generic NSError object filled up if an error occurs.
        */
}];
```

## Dependencies

Foundation

[AFNetworking](https://github.com/AFNetworking/AFNetworking)

## License

```
Copyright (c) 2013 Mert Dümenci

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
```

***

This project uses [AFNetworking](https://github.com/AFNetworking/AFNetworking). It's added as a submodule. (git submodule update --init)

```
Copyright (c) 2011 Gowalla (http://gowalla.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
