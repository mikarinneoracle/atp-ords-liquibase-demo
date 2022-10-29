## Instructions

<i><b>prereq: oci cli must be working in oci cloud shell</b></i>

### Part 1 - deploying single page app with ATP, ORDS and APEX using oci cli and LB in cloud shell
<p>
Open oci cloud shell

<p>
Run <code>git clone https://github.com/mikarinneoracle/atp-ords-liquibase-demo.git</code>

<p>
Edit <code>script.sh</code> with oci code editor<br>
    => add your oci compartment by replacing <i>&lt;YOUR COMPARTMENT OCID&gt;</i> and the <i>region</i> if necessary (lines 1-2):

<p>
<pre>
export region='eu-amsterdam-1'
export compt_ocid='&lt;YOUR COMPARTMENT OCID&gt;'
</pre>

<p>
Run <code>sh script.sh</code>code>

<p>
Script will create "pricing" ATP instance and update the database with a schema, ORDS and APEX with Liquibase.
Then it will update the html content with generated url's and upload the the content to the "pricing" Object Storage bucket.
    
<p>
Access <i>pricing bucket</i> from your browser and open the <code>index.html</code>
    
<p>
After making sure the html page works (do a few reloads to the page if necessary) delete resources manually.

### Part 2 - deploying single page app with ATP, ORDS and APEX using Terraform (oci resource manager stack and JSON)
<p>
Open oci cloud shell

<p>
Run <code>git clone https://github.com/mikarinneoracle/atp-ords-liquibase-demo.git</code>

<p>
Edit <code>script-tf-json.sh</code> with oci code editor<br>
    => add your oci compartment by replacing <i>&lt;YOUR COMPARTMENT OCID&gt;</i> and the <i>region</i> if necessary (lines 1-2):

<p>
<pre>
export region='eu-amsterdam-1'
export compt_ocid='&lt;YOUR COMPARTMENT OCID&gt;'
</pre>

<p>
Run <code>sh script-tf-json.sh</code>

<i>note:</i> If you run Part 2 right after Part 1, first delete the "pricing" resources manually (ATP and Object Storage).

<p>
Script will run in 2 parts.
First it will create a Resource Manager Terraform Stack and update it with <code>vars.json</code> to create the infra for the same resources as in Part 1.
Then it will update the RM Terraform Stack with <code>vars.json</code> having the generated url's and run the Stack again to update the  html content in Object Storage.

<p>
Access <i>pricing bucket</i> from your browser and open the <code>index.html</code>
    
<p>
After making sure the html page works (do a few reloads to the page if necessary) delete all created resources with Terraform by clicking <code>destroy</code> on the RM Stack in the cloud console.

### See on Youtube

Part 1: <a href="https://www.youtube.com/watch?v=80CWk2baJy4">https://www.youtube.com/watch?v=80CWk2baJy4</a>