#import "GTMSenTestCase.h"
#import "FKNewtype.h"

NEWTYPE(Age, NSString, age);
NEWTYPE(Name, NSString, name);
NEWTYPE2(Person, Age, age, Name, name);
NEWTYPE3(Position, Person, occupier, NSString, title, NSDate, started);

NEWTYPE2(Simple2, NSString, a, NSString, b); 
NEWTYPE3(Simple3, NSString, a, NSString, b, NSString, c); 

@interface FKNewtypeTests : GTMTestCase
@end

@implementation FKNewtypeTests
- (void)testTypes {
	Age *age = [Age age:@"54"];
	Name *name = [Name name:@"Nick"];
	Person *nick = [Person age:age name:name];
	Position *p = [Position occupier:nick title:@"Dev" started:[NSDate date]];
	STAssertEqualObjects(age.age, @"54", nil);
	STAssertEqualObjects(nick.name.name, @"Nick", nil);
	STAssertEqualObjects(p.title, @"Dev", nil);
}

- (void)testValidArrayCreation {
	id <FKFunction> fromArray = [[NSArrayToAge new] autorelease];
	id fromValid = [fromArray :[NSArray arrayWithObject:@"54"]];
	STAssertTrue([fromValid isSome], nil);
	STAssertEqualObjects([fromValid some], [Age age:@"54"], nil);
	
	id <FKFunction> fromArray2 = [[NSArrayToPerson new] autorelease];
	id fromValid2 = [fromArray2 :[NSArray arrayWithObjects:[Age age:@"54"], [Name name:@"Nick"], nil]];
	STAssertTrue([fromValid2 isSome], nil);
	STAssertEqualObjects([fromValid2 some], [Person age:[Age age:@"54"] name:[Name name:@"Nick"]], nil);
	
	id <FKFunction> fromArray3 = [[NSArrayToSimple3 new] autorelease];
	id fromValid3 = [fromArray3 :[NSArray arrayWithObjects:@"a", @"b", @"c",nil]];
	STAssertTrue([fromValid3 isSome], nil);
	STAssertEqualObjects([fromValid3 some], [Simple3 a:@"a" b:@"b" c:@"c"], nil);
}

- (void)testWrongSizeArrayCreation {
	id <FKFunction> fromArray = [[NSArrayToAge new] autorelease];
	
	id fromEmpty = [fromArray :EMPTY_ARRAY];
	STAssertTrue([fromEmpty isKindOfClass:[FKOption class]],nil);
	STAssertTrue([fromEmpty isNone], nil);
	
	id fromTooBig = [fromArray :NSARRAY(@"54", @"55")];
	STAssertTrue([fromTooBig isKindOfClass:[FKOption class]],nil);
	STAssertTrue([fromTooBig isNone], nil);
}

- (void)testWrongTypeArrayCreation {
	id <FKFunction> fromArray = [[NSArrayToAge new] autorelease];
	id fromWrongType = [fromArray :NSARRAY([NSNumber numberWithInt:54])];
	STAssertTrue([fromWrongType isKindOfClass:[FKOption class]],nil);
	STAssertTrue([fromWrongType isNone], nil);
}

- (void)testValidDictionaryCreation {
	id <FKFunction> fromDict = [[NSDictionaryToAge new] autorelease];
	FKOption *result = [fromDict :NSDICT(@"54", @"age")];
	STAssertTrue(result.isSome, nil);
	STAssertEqualObjects(result.some,[Age age:@"54"], nil);
	
	id <FKFunction> fromDict2 = [[NSDictionaryToSimple2 new] autorelease];
	result = [fromDict2 :NSDICT(@"bval", @"b", @"aval", @"a")];
	STAssertTrue([result isSome], nil);
	STAssertEqualObjects([result some], [Simple2 a:@"aval" b:@"bval"], nil);
	
	id <FKFunction> fromDict3 = [[NSDictionaryToSimple3 new] autorelease];
	result = [fromDict3 :NSDICT(@"bval", @"b", @"aval", @"a", @"cval", @"c")];
	STAssertTrue([result isSome], nil);
	STAssertEqualObjects([result some], [Simple3 a:@"aval" b:@"bval" c:@"cval"], nil);
}

- (void)testInvalidDictionaryCreation {
	id <FKFunction> fromDict = [[NSDictionaryToAge new] autorelease];
	FKOption *result = [fromDict :NSDICT(@"54", @"ages")];
	STAssertTrue(result.isNone, nil);
}
@end

