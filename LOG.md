2013-08-17 - Afternoon
----------------------

Very beginnings, Started with classes and related skills. 

Most of the actual work this afternoon was on data loading (for internal data, not working data).

System data comes from CSV files in db/seed_tables.
The naming convention for this is:

numeric index, then the underscored, plural class name.
E.G. 01-character_classes.csv

Headers are methods to run on a newly created object:

* Those ending in = are set before saving the object
* Others are called afterwards (mostly to set relationships by name, after saving)

These are run at db:seeds, and the 'check' method on any model is called as you go. 

Check methods are a simple summary, but can also be used to weed out problems, which are then shown 
at the end of the seed loading. See app/models/character_class.rb for a strong pattern.

Hopefully, next time I`ll get closer to some game mechanics.

2013-08-17 - Evening
--------------------

This session was:
* putting in Character and it`s relationship to skills.
* Levelling up and aquiring skills (barely tested)
* Creating a very simple battle scenario (/test/unit/battle_test.rb)

This is actually a bit of a coup for me, that it`s reached this stage so quickly.
Eventually I hope to use range and speed, to make a dynamic, grid-based game, but this
is a definite step fowards. And it`s 11:41 on a Saturday night. Don`t forget that!

2013-08-18 - Afternoon
----------------------

This was mostly a testing session, using mocha to remove chance operations from rolls.

Very little new development today, but yesterdays work is a lot more solid than it has been.
The next step is probably a bit more of the battle scenario test.

2013-08-19 - Evening
--------------------

Once again, working until 11.

This time it was a test-driven run at attribute modifying effects, namely reducing armour
and increasing attack power. The test`s half-and-half completed and there`s a whole new model
for effects in play. The whole project is definitely stepping forwards in slow, well tested lumps.

I didn`t get round to a full scenario test, perhaps another time.
