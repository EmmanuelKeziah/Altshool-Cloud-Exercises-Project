## Assignment:
Learn how to set timezones with Linux.

## Solution
### Description
This script consists of Linux commands that allow you to set the time and timezone on your system.

### Listing the available timezones
To list all available timezones in alphabetical order, use the following command:
## `sudo timedatectl list-timezones`:
This Linux command will return a long list of all timezones available in the world in A-Z format as seen in the screenshot below

*![Using the `sudo timedatectl list-timezones` command](Screenshots/time_zone_list.jpg)*

### Searching for timezones in a specific country/Continent:
To search for timezones in a specific country, use the following command:
## `sudo timedatectl list-timezones | grep <country>`: 
This Linux command  display a long list of all timezones available in a specific country and output the results. This is a shorter list than the one returned by the `sudo timedatectl list-timezones` command. The screenshot below shows the output of the continents "Europe" and "Asia" when the `sudo timedatectl list-timezones | grep <country>` command is used.

*![Using the `sudo timedatectl list-timezones | grep <country>` command](Screenshots/time_zone_list_grep.jpg)*


### Setting the default time and date:
To set the default time and date, use the following command:
## `sudo timedatectl set-time "YYYY-MM-dd HH:MM:SS"`:
This Linux command sets the default time and date to a particular year, month, day, hour, minute, second and the results can be displayed uding the `timedatectl` command as seen below:

*![Using the `sudo timedatectl set-time "YYYY-MM-dd HH:MM:SS"` command](Screenshots/setting_timezone.jpg)*

