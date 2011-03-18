//
//  ModelObject.h
//  WordPressReimagined
//
//  Created by Peter Boctor on 3/17/11.
//
//  Copyright (c) 2011 Peter Boctor
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

@interface ModelObject : NSObject
{
  NSDictionary* attributes;

  UIImage* image;
  NSMutableData* imageData;
  NSURLConnection *imageConnection;
  NSString* imageURLKey;
  NSString* genericImageName;
  NSString* verticalOffsetKey;

  NSString* uniqueIdentifierKey;
}

@property (nonatomic, retain) NSDictionary* attributes;

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSMutableData* imageData;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) NSString* imageURLKey;
@property (nonatomic, retain) NSString* genericImageName;
@property (nonatomic, retain) NSString* verticalOffsetKey;

@property (nonatomic, retain) NSString* uniqueIdentifierKey;

-(void) startDownloadingImageIfNeeded;
-(void) cancelDownloadingImage;
-(void) useGenericImage;

-(id) initWithAttributes:(NSDictionary*)theAttributes;
-(id) objectForKey:(id)key;

-(void) adjustImageVerticallyUsing:(UIImageView*)imageView;
@end
