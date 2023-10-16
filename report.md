# REPORT

## Context

- Design choices
- List potential red flags in the current solution
- Things I would do differently
- Time you spent working on the project
- Issues I had/what took me longer than expected


====
ideas:

- Alerts might need to be filterable by health center, since the information of one center's patients is relevant for the caregivers of that center. Then, it's handy to add a reference number to the health center, so external APIs can use that ID to search for an specific center without having access to internal id information.
- Caregivers are assumed to be associated to only one Health Center, that could be false in the reality but for now we're not considering shifts (which could also alter the staff's availability for responding alerts) so this assumption seems acceptable as a first approach.
- Additional information field in the patient table is of type text to allow more data insertion than usual.
- Usually addresses need some kind of formating which, between other things, helps making sure we're collecting all the information needed in order to build a proper address.