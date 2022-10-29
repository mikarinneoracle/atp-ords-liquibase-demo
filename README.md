## Instructions

<b>prereq: oci cli must be working in oci cloud shell</b>

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

<p>
Script will run in 2 parts.
First it will create a Resource Manager Terraform Stack and update it with <code>vars.json</code> to create the infra for the same resources as in Part 1.
Then it will update the RM Terraform Stack with <code>vars.json</code> having the generated url's and run the Stack again to update the app html content.

<p>
access <i>pricing bucket</i> from your browser and open the <code>index.html</code>

### See on Youtube

Part 1: <a href="https://www.youtube.com/watch?v=80CWk2baJy4">https://www.youtube.com/watch?v=80CWk2baJy4</a>