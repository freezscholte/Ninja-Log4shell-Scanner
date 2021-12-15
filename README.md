# Ninja-Log4shell-Scanner
Log4Shell Scanner For Ninja RMM

This script can be used within any RMM but I made this one specific for NinjaRMM since that is what we use.
Cleanest way is to use it with Custom Fields so you can export a csv from Ninja with all the entry's.

To organize it even more, we created in Ninja Ticketing a custom board specially for Log4Shell detection.

1. First we need to create the "Log4shell" tag, this can be done by opening a existing ticket and add a new tag there. Afther adding the new tag you can delete it here. So far I know this is the only way to create new tags.
2. Then within Ninja Ticketing settings (Settings -> Integrations - Ninja Ticketing) create a new Ticket Board "Log4shell Files" or some other name you like. There you choose actions: Tags -> Contains Any -> "Log4shell"
3. Then under automation create a "Condition Rule" Name "Search Log4Shell Files" and add the "Log4shell" Tag.
4. Then create a scheduled script in you policy were you want to deploy you Log4shell scanner
5. In the same policy create a new "Condition" Choose -> Custom Fields and then set "Custom field value must meet any conditions" 
Choose the custom field you created earlier -> contains -> "Warning" since that is the word we use in our output when it finds actually something.

