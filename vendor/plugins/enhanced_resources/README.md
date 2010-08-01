Enhanced Resources
==================
A simple Rails 2 plugin that extends classes who inherit from ActiveResource with caching and request limitation features. These were developed specifically for [this application](http://github.com/sdale/bblue_crm) but I decided to modularize the code a bit more and make it available as a plugin.

Features
--------

### Caching
All object collections are cached into your Rails environment's cache store. This way you can browse through your application without having to load object collections from their external source all the time, reducing request time from minutes to miliseconds.

Caching is divided into 2 groups:
* Lazy: fast, inconsistent. On the first request the data is all cached and never recaches again until you explicitely tell it to (via some rake task or script/console). Smart choice for large collections that rarely change.
* Eager: slow, consistent. At every request the system checks for a change in the object collection and recaches case there is one. Smart choice for small collections that are always changing.

To pass a caching option such as lazy or eager on, you can use the caching option:

	class Person < ActiveResource::Base
		def self.find_eager
			self.find(:all, :caching => 'eager')
		end
	end

If you do not want to use caching on a request, you may pass a disable caching option:

	class Person < ActiveResource::Base
		def self.find_without_caching
			self.find(:all, :disable_caching => true)
		end
	end

Be sure to have a way to recache lazy data at will. I accomplish this with a rake task such as [this one](http://github.com/sdale/bblue_crm/blob/master/lib/tasks/recache.rake)

### Request Limitation
Object collection requests are broken down into smaller requests (and bundled up together in the end) to avoid (or at least lessen the rist of) request timeouts.
Example: if you're asking for 400 objects and set the request limit to 100, 4 requests of 100 objects will be made (0~100, 100~200, 200~300, 300~400) instead of a single one (0~400). In the end all requests are bundled up so there's no difference to the end user.

The request limit default is 100, but you can set your own using the request_limit option:

	class Person < ActiveResource::Base
		def self.find_a_bunch
			self.find(:all, :request_limit => 400)
		end
	end

If you do not want to use request limitation on a request, you may pass a disable request limitation option:

	class Person < ActiveResource::Base
		def self.find_without_limitation
			self.find(:all, :disable_request_limitation => true)
		end
	end

Important Notes
---------------
Since this was originally designed to deal with the [BatchBook CRM API](http://developer.batchblue.com/), these features will *only* work if the backend server (the one who's supplying objects) implements:

* Both 'limit' and 'offset' parameters. Required for the request limitation feature.
* An 'updated_since' parameter. Required for the caching feature (eager caching).

Both 'limit' and 'offset' parameters are usually implemented by backend hosts, but 'updated_since' is more specific, so if your host doesn't implement it then it's time to get your hands dirty and modify the Caching module to suit your needs.