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
