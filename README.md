# X-SUNIT

The X-SUNIT is a dev challenge I'm solving for a dev internship I applied. The needed documentation is found below.


## Problem Description

The world as we know it has fallen into an apocalyptic scenario. An alien invasion is abducting humans and swapping them for evil clones that look really similar to the original person.


You, as a X-SUNIT member (and the last survivor who knows how to code), was designated to develop a system to share resources between non-abducted humans.


## Requirements

You will develop a REST API (yes, we care about architecture design even in the midst of an alien apocalypse!), which will store information about the survivors.

In order to accomplish this, the API must fulfill the following use cases:

- Add survivors to the database

  A survivor must have a name, age, gender and last location (latitude, longitude).

- Update survivor location

  A survivor must have the ability to update their last location, storing the new latitude/longitude pair in the base (no need to track locations, just replacing the previous one is enough).

- Flag survivor as abducted

  In a chaotic situation like that, it's inevitable that a survivor may get abducted. When this happens, we need to flag the survivor was abducted.

  A survivor is marked as abducted when at least three other survivors report their abduction.

- Reports

The API must offer the following reports:

  1. Percentage of abducted survivors.
  2. Percentage of non-abducted survivors.
  3. List of all survivors names, by alphabetic order, with an identification to know who was abducted.

## Routes

Consider the base api as ''http://localhost:3000, the following routes are implemented:

''GET /api/v1/survivors
Returns response.survivors, wich is an array of all survivors

''POST /api/v1/survivors
Inserts the json sent in the database

json example:
''{
''  "name": "Jacob",
''  "age": 20,
''  "gender": "m",
''  "latitude": -76.4560
''  "longitude": 32.8909
''}


''GET /api/v1/survivors/:id
Returns response.survivor, wich is the one indicated by the id