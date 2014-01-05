---
layout: default
date: 2013-12-06 17:42:00
title: "Unit testing framework in C++: fixtures"
---
I have two tests. 
    
```c++
TEST(should_hurt_monster_if_cell_hurts)  
{  
	Game game;  
	game.level.map = Map(2, 2);  
	Item armor = Item::Builder().sprite(1).wearable().defence(3).name("item");  
	game.level.monsters.push_back(Monster::Builder().pos(Point(1, 1)).hp(100).name("dummy").item(armor));  
  
	game.level.map.celltypes[0].hurts = true;  
	game.process_environment(game.level.monsters.front());  
	EQUAL(game.level.monsters.front().hp, 99);  
	EQUAL(game.messages, MakeVector("It hurts!")("Dummy loses 1 hp.").result);  
}  
  
TEST(should_hurt_monster_is_poisoned)  
{  
	Game game;  
	game.level.map = Map(2, 2);  
	Item armor = Item::Builder().sprite(1).wearable().defence(3).name("item");  
	game.level.monsters.push_back(Monster::Builder().pos(Point(1, 1)).hp(100).name("dummy").item(armor));  
  
	game.level.monsters.front().poisoning = 10;  
	game.process_environment(game.level.monsters.front());  
	EQUAL(game.level.monsters.front().hp, 99);  
	EQUAL(game.messages, MakeVector("Dummy is poisoned.")("Dummy loses 1 hp.").result);  
}  
```
    
DRY principle wouldn't let me use this. There are same code snippets used in both tests, in which game objects prepares. Practically it is setup step for the test. So I want to have prepared game object before I even enter test function, and possibly same object for both of test functions. So I declare a test fixture: 
    
```c++
struct GameWithDummy {  
	Game game;  
	GameWithDummy() {  
		game.level.map = Map(2, 2);  
		Item armor = Item::Builder().sprite(1).wearable().defence(3).name("item");  
		game.level.monsters.push_back(Monster::Builder().pos(Point(1, 1)).hp(100).name("dummy").item(armor));  
	}  
};  
```

Now I want to use it in test. Sure, it could be passed as a variable like 'fixture', but in this case 'fixture.' prefix would be needed for addressing each field. Which is in turn a violation of DRY principle. Yet, I could left my test as they are (without any prefixes), if each test function were fixture class' function. I inherit new class, Fixture_GameWithDummy, define run() method, and in Test::run() function I just create fixture object and call its run() method, and all testing will be contained in fixture::run(). 
    
```c++
#define TEST_FIXTURE(fixture_name, test_name) \  
	class Fixture_##fixture_name##test_name : public fixture_name { \  
	public: \  
		void run(); \  
	}; \  
	class Test_##test_name : public Test {  \  
	public:  \  
		Test_##test_name(const char * suite, const char * name) : Test(suite, name) {}  \  
		virtual void run();  \  
	};  \  
	Test_##test_name test_##test_name(current_suite_name(), #test_name);  \  
	void Test_##test_name::run() \  
	{ \  
		Fixture_##fixture_name##test_name fixture; \  
		fixture.run(); \  
	} \  
	void Fixture_##fixture_name##test_name::run()  
```

This step requires all tests to be converted from simple `void(*)()` function to a class, which really isn't complicate anything: 
    
```c++
struct Test {  
	const char * suite;  
	const char * name;  
	Test(const char * test_suite, const char * test_name);  
	virtual ~Test() {}  
	virtual void run() = 0;  
	bool specified(int argc, char ** argv) const;  
};  
  
#define TEST(test_name) \  
	class Test_##test_name : public Test { \  
	public: \  
		Test_##test_name(const char * suite, const char * name) : Test(suite, name) {} \  
		virtual void run(); \  
	}; \  
	Test_##test_name test_##test_name(current_suite_name(), #test_name); \  
	void Test_##test_name::run()  
```

Now test runner just need to treat each test object as a class instance, not function, and call it's run() method instead of impl().   
  
And original two tests are simplified now: 
      
```c++
TEST_FIXTURE(GameWithDummy, should_hurt_monster_if_cell_hurts)  
{  
	game.level.map.celltypes[0].hurts = true;  
	game.process_environment(game.level.monsters.front());  
	EQUAL(game.level.monsters.front().hp, 99);  
	EQUAL(game.messages, MakeVector("It hurts!")("Dummy loses 1 hp.").result);  
}  
  
TEST_FIXTURE(GameWithDummy, should_hurt_monster_is_poisoned)  
{  
	game.level.monsters.front().poisoning = 10;  
	game.process_environment(game.level.monsters.front());  
	EQUAL(game.level.monsters.front().hp, 99);  
	EQUAL(game.messages, MakeVector("Dummy is poisoned.")("Dummy loses 1 hp.").result);  
}  
```

