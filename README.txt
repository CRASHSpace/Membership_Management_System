This is just a skeleton. Does not yet function.

This system automates part of the process of handling membership payments.
This is Phase 1: Basic Automation
Phase 2 entails: Automating the parts that are listed here as manual
Phase 3 entails whatever fancy shit we dream up

These are the use cases covered:
-A new member can sign up
-A current member can change membership tiers
-A member can be late on payments
-A member can decide to no longer be a member

Here is how the system works:
* Download a csv of payment information from paypal
* System scrapes out any members who have changed tiers (they must be acted upon manually)
* System scrapes out any members who are new (they must be acted upon manually)
* System updates database with each member's most recent payment

Coming Soon:
* System reads everyone's last payment date from database
* If member is late on payment, have they been notified before?
** If not, send nastygram (update db with info on nastygram)
** If so, send nastier gram (update db with info on nastygram)
** If so twice already, send nastiest gram (update db with info on nastygram) (they must be acted upon manually)
* System notices canceled payment (must be acted upon manually)

TO DO:
* Files must be cleaned before being loaded (check for commas, remove crap from end of file, remove ^M)






