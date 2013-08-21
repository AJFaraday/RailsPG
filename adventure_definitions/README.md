RailsPG adventure definitions
-----------------------------

In concept an adventure can be defined in a folder under /adventure_definitions
then be loaded as a playable level. 

Each definition consists of:

* specification.yml
* one or more play space .csv files

The CSV files define a play area with these keys (n denotes a number from 1 upwards):

* pn: a player starting position.
* en: an enemy starting position.
* dn: a doorway to another play space
* o: an obstacle
* (empty cells): passable space

The specification should contain:

* Name:
* Description:
* Playspaces
** Name
** Rows
** Columns
** Filename
** Enemies
*** Name
*** Class
*** level
*** skills
**** skill_name
**** level
** Players
*** Name
*** Class
*** Level
** Doors
*** Destination (play space)

Notes:
* This really is just speculation at this stage - 2013-08-20
* look at /adventure_definitions/00-snails-on-rails/specification.yml