# REPORT

## Context

- Design choices
- List potential red flags in the current solution
- Things I would do differently
- Time you spent working on the project
- Issues I had/what took me longer than expected


## Ideas:

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
- Doesn't feel as a good decision to me to filter by exact datetime of the reception of the alert since it seems to be too much precision (maybe for the use case it actually makes sense though).
For now I'll implement what makes sense to me, which is taking into account a range of 1 minute surrounding the input received for the filter (it could be taken down to the second to make it more restricted).

## Notes on Level 4

Many implementation details were left out in this level. For now, lacking data from the field, I'll go to a simple approach in which I'll notify a caregiver following a queue logic for sending the messages.

This raises the problem:
- The caregiver might not be available at the time he/she's notified. We can tackle that problem in different ways, some I've thought of:
  - We need to have a way to know about the caregivers' availability. We could, for example, save the weekly schedules and daily changes on status with a web/phone app that can be used by the health center.
  - The caregiver could respond the SMS received with the status 'unavailable'. After receiving this response we could reassign the alert to another caregiver. This option raises other complexities, like identifying which alert the response is referring to (for example, might be necessary to mark previous alerts as completed), the key word received is error prone since is just typed manually by the caregiver, when to mark the caregiver as available again.. and I'm sure there's many more haha.
  - A way to guarantee that the alert is attended and reduce the reaction time to the minimum, we could broadcast the message to all caregivers. But, how can a caregiver notify others he/she will attend an alert? This brings many other implementation details to think about, similar to the previous point. But it could be an implementation similar of a group messaging solution, where is possible to identify the alert they are responding to.

Other implementation notes:

- Sidekiq is the service running the background jobs. It relies on Redis, which (after configuring it to don't pop the job out of the memory until it's completed) is quite reliable in terms of failure of the worker server running the job.
  Then the failure point would be Redis crashing. For that Redis also provides an option of back up the data in DB, which would prevent loosing the data of unsent messages.

- Note that handling errors during saving the alert is as important as the creation of the caregiver message to guarantee the patient is visited. The execution of the notification happens only after the alert is successfully created.

- Creating a table **messages** that serves as a link between alerts and caregivers (is basically the assignation of caregivers) allows us to validate that two or more caregivers are not assigned to respond the same alert and finally implement a sort of queue by blocking the DB whenever an assignation is being made (I'd need to check better about this correctly implementing a queue for assigning caregivers, I'm not completely sure - it feels it doesn't - :S but is the best approach I can think of right now).


## Level 6: Ideation

How would you solve these issues?

- Caregiver does not receive the SMS or is not near its phone
Having the message broadcasted would reduce the dependency on any particular caregiver to respond.

Besides that, maybe having a specific device for this kind of messages could also be an option to reduce this problem, I’m thinking of something like doctors’ pagers.

- How does the care giver enters the patient's house?
An idea is to have the instructions in the **additional information** field, however, it's error prone and could failed in case, for example, the neighbor having the key is not home.

Another idea could be to have lockers, maybe outside the patient house or in the health centers, so that all care givers can have access to the keys when they need it.

Might be even better if the lockers can use a password to open. The password would be then shared only to the caregiver that is attending the alert and then reset afterwards... it'd need to be a very reliable system though.

- What if our system is down? Any ways to limit point of failure?
Replicas in different server services could help limiting the risk of having our system down. Also the previous discussion regarding Sidekiq and Redis is a way to limit point of failures sending the messages. Another idea might be having an emergency system connecting the patient directly to the caregiver in a more simpler way, with a very simple logic that actives only if needed.