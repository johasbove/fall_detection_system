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
- Caregivers' first and last name might be needed in the future to solve situations stated in Level 6.
- Twilio use: there's a gem called `twilio-ruby` that allows us to connect to our account. For that we would need to set our credentials
- Alerts' table could be use for saving received but also sent messages, however I decided not to do that because:
  - Both data points will potentially grow very quickly and having the same table growing at a fast pace from two different sources would be harder to manage.
  - The two types of messages could need different logic for purging the records (for example, we could decide to delete the received messages after a specific period of time and sent messages after a much shorter period, maybe after it's confirmed as received for example). Then, it's better to have the records in different tables for implementing specific logic.
- Building the parsing services and its tests took longer than expected.
- Might be a good idea to add some handling of invalid alerts in the alerts' content validator. What I'm thinking is that invalid alerts could be related to problems in the patients' devices, which would be important to notify either to the health centers or to the people responsible for those. Then adding some emailing or other kind of messaging with aggregated failing information might be a good idea. For that we could either save that data until the report is sent or triggering a custom error and track them in our error handling services. Two of these options would be implemented inside of the Alerts::ContentValidator service.
- I'm not a fan of how the errors are being added to the response string :/