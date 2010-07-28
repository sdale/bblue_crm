Read the full documentation on [our wiki](http://wiki.github.com/sdale/bblue_crm/)
=================================================================================

BatchBook Integration
---------------------

We at [UsedCisco.com](http://www.usedcisco.com) use [BatchBook CRM](http://batchblue.com/product-info.html) and build custom tools using their API to fill gaps that our business requires.

### Technical Notes

* Installation and Configuration 
* Setting Up Users
* Contacts Management
* Deals Management
* Performance
* Testing
* Utility Tasks
* Misc Notes

### Business Notes

BatchBooks is an excellent cloud-based CRM service. 
Although it is growing quickly and already has a nice mature API, every business has specific needs, 
and we found some gaps that needed to be addressed.

The first step for us was to get familiar with the API and create some simple custom reporting tools. 
This is currently where development stands.

The second step is going to be to automate some of the workflow tasks for the internal sales team, 
for example, converting a lead (prospect) to a customer. Using the API, we can have that happen in one step.

The third and most involved task will be integrating our custom quoting web application 
with BatchBook. BatchBook currently has no way of creating a quote in the system, using an 
inventory list of our products. We don't want it to: adding too many features will make it 
overly complex by trying to cater to so many different business, ahem, SalesForce. 
Instead, we will build the system we need, and use the API to handle integration. 

Check back soon, as we will beginning building stages 2 and three shortly. 
Most importantly, please offer feedback and feel free to extend it. 
The critical part though is understanding how we use the system currently, and building on this correctly.

*******************************
*Rough business overview*

* We use a system of tagging individuals and contacts as either leads (prospects) or customers to indicate
  status and ownership. 

* Deals are created for either, and when a deal is won, we remove the Lead tag and add the Customer tag.

* A task is created to remind our salesperson to follow up with the customer, and we assign ownership of 
  the customer to the salesperson who closed the deal using an Ownership SuperTag (dropdown select of the 
  salesperson User).

* Each deal gets a SuperTag called dealinfo. In it are a few fields that is used in reporting and filtering

*******************************
*Current Functionality*

* A more detailed pipeline reporting system that the stock BatchBooks. Using SuperTags to calculate custom 
  fields and filters. The goal is to easily see each salesperson's deals, current status and a pseudo pipeline.

* To ensure integrity, we also wrote some rake scripts/cron jobs to generate reports for us weekly of 
  which contacts do not have ownership, or do not have either the Lead or Customer tag.

*******************************
*To Do*

* Deal close date filtering (dependent on deal SuperTags via the API, waiting ... )
* Add check for deals without the dealinfo SuperTag to cron jobs (waiting, same as above)
* Link custom quoting app with BB

*******************************
### Extend it!

If our business model of dealing with the CRM suits you, awesome, you gain a whole application for free, but if it doesn't, feel free to create your own features and be sure to share it with us!