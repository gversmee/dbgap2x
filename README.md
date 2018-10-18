[![Binder](http://35.229.102.164/badge.svg)](http://35.229.102.164/v2/gh/gversmee/dbGaP2x/master?filepath=dbGaP2x%2FdbGaP2x.ipynb)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![DOI](https://zenodo.org/badge/153461909.svg)](https://zenodo.org/badge/latestdoi/153461909)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/gversmee/dbgap2x/)

# Using dbGaP2x, R package to explore and sort phenotypics data from dbGap

You can test this software:
- Using binder, by clicking the "launch binder" badge above.
- Using the dockerized version on your local device by running


```bash
docker run -p 80:8888 -v /var/run/docker.sock:/var/run/docker.sock -u root gversmee/dbgap2x
```

and then open your web browser at http://localhost, and use the password `versmee`
- Using your local R by installing the package with


```R
devtools::install_github("gversmee/dbGaP2x")
```

## Introduction
### Load the package


```R
#devtools::install_github("gversmee/dbGaP2x", force = TRUE)
library(dbGaP2x)
```

### Get the list of the function for this new package


```R
lsf.str("package:dbGaP2x")
```


    browse.dbgap : function (phs, jupyter = FALSE)  
    browse.study : function (phs, jupyter = FALSE)  
    consent.groups : function (phs)  
    datatables.dict : function (phs)  
    dbgap.data_dict : function (xml, dest)  
    dbgap.decrypt : function (files, key = FALSE)  
    dbgap.download : function (krt, key = FALSE)  
    is.parent : function (phs)  
    n.pop : function (phs, consentgroups = TRUE, gender = TRUE)  
    n.tables : function (phs)  
    n.variables : function (phs)  
    parent.study : function (phs)  
    phs.version : function (phs)  
    search.dbgap : function (term, jupyter = FALSE)  
    study.name : function (phs)  
    sub.study : function (phs)  
    variables.dict : function (phs)  


## 1. Search for dbGap studies
### Let's try to explore the "Jackson Heart Study" cohort that exists on dbGap.
###### The dbGap search engine can be tricky, that's why we created the function "browse.dbgap", who helps you find the studies related to the term that you search on your web browser.
Note that if you run this function in a jupyterhub environment, it will return a url since jupyterhub doesn't have access to your local browser.


```R
search.dbgap("Jackson", jupyter = TRUE)
```


'https://www.ncbi.nlm.nih.gov/gap/?term=Jackson%5BStudy+Name%5D'


#### dbGap returns the list of the studies related to your term. As you see, there are 6 studies associated with the "Jackson Heart Study" (JHS). One of these study is the main one aka the "parent study", whereas the other ones are substudies. In this case, phs000286.v5.p1 is the parent study. Firslty, we can use the phs.version() function in order to be sure that this is the latest version of the study. We can abbreviate the phs name by giving just the digit, or we can use the full dbGap id.


```R
phs.version("286")
```


'phs000286.v5.p1'


##### The is.parent() function is usefull to test if a study is a parent study or a substudy


```R
is.parent("000286") # JHS main cohort
is.parent("phs499") # substudy "CARe" for JHS
```


TRUE



FALSE


#### If you don't know the parent study of a substudy, try parent.study()


```R
parent.study("phs000499")
```


<ol class=list-inline>
	<li>'phs000286.v5.p1'</li>
	<li>'Jackson Heart Study (JHS) Cohort'</li>
</ol>



##### On the other side, use sub.study() to get the name and IDs of the substudies from a parent one


```R
sub.study("286")
```


<table>
<thead><tr><th scope=col>phs</th><th scope=col>name</th></tr></thead>
<tbody>
	<tr><td>phs000499.v3.p1                                                     </td><td>NHLBI Jackson Heart Study Candidate Gene Association Resource (CARe)</td></tr>
	<tr><td>phs000498.v3.p1                                                     </td><td>Jackson Heart Study Allelic Spectrum Project                        </td></tr>
	<tr><td>phs000402.v3.p1                                                     </td><td>NHLBI GO-ESP: Heart Cohorts Exome Sequencing Project (JHS)          </td></tr>
	<tr><td>phs001098.v1.p1                                                     </td><td>T2D-GENES Multi-Ethnic Exome Sequencing Study: Jackson Heart Study  </td></tr>
</tbody>
</table>



##### If you want to get the name of a study from its dbGap id, use study.name()


```R
study.name("286")
```


'Jackson Heart Study (JHS) Cohort'


##### Finally, you can watch your study on dbGap with browse.dbgap().
##### If a website exists for this study, you can browse it using browse.study()


```R
browse.dbgap("286", jupyter = TRUE)
browse.study("286", jupyter = TRUE)
```


'https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs000286.v5.p1'



'https://www.jacksonheartstudy.org'


## 2. Explore the characteristics of your study
##### For each dbGap study, there can be multiple consent groups that will have there specificities. Use consent.groups to know the number and the name of the consent groups in the study that you are exploring. Let's keep focusing on JHS.


```R
JHS <- "phs000286"
consent.groups(JHS)
```


<table>
<thead><tr><th></th><th scope=col>shortName</th><th scope=col>longName</th></tr></thead>
<tbody>
	<tr><th scope=row>0</th><td>NRUP                                                                                                                                                                             </td><td>Subjects did not participate in the study, did not complete a consent document and are included only for the pedigree structure and/or genotype controls, such as HapMap subjects</td></tr>
	<tr><th scope=row>1</th><td>HMB-IRB-NPU                                                                                                                                                                      </td><td>Health/Medical/Biomedical (IRB, NPU)                                                                                                                                             </td></tr>
	<tr><th scope=row>2</th><td>DS-FDO-IRB-NPU                                                                                                                                                                   </td><td>Disease-Specific (Focused Disease Only, IRB, NPU)                                                                                                                                </td></tr>
	<tr><th scope=row>3</th><td>HMB-IRB                                                                                                                                                                          </td><td>Health/Medical/Biomedical (IRB)                                                                                                                                                  </td></tr>
	<tr><th scope=row>4</th><td>DS-FDO-IRB                                                                                                                                                                       </td><td>Disease-Specific (Focused Disease Only, IRB)                                                                                                                                     </td></tr>
</tbody>
</table>



##### Use n.pop() to know the number of patient included in each groups


```R
n.pop(JHS)
n.pop(JHS, consentgroups = FALSE)
```


<table>
<thead><tr><th scope=col>consent_group</th><th scope=col>male</th><th scope=col>female</th><th scope=col>total</th></tr></thead>
<tbody>
	<tr><td>HMB-IRB       </td><td>1860          </td><td>2504          </td><td>4549          </td></tr>
	<tr><td>HMB-IRB-NPU   </td><td> 264          </td><td> 505          </td><td> 802          </td></tr>
	<tr><td>DS-FDO-IRB-NPU</td><td>  63          </td><td> 107          </td><td> 180          </td></tr>
	<tr><td>HMB-IRB       </td><td> 784          </td><td>1232          </td><td>2131          </td></tr>
	<tr><td>DS-FDO-IRB    </td><td> 173          </td><td> 289          </td><td> 489          </td></tr>
	<tr><td>TOTAL         </td><td>3144          </td><td>4637          </td><td>8151          </td></tr>
</tbody>
</table>




8151


##### Use n.tables() and n.variables() to get the number of datatables in your study and the total number of variables
(n.variables goes into the study files to count the actual number of variables)


```R
n.tables(JHS)
n.variables(JHS)
```


66



4326


#### datatables.dict() will return a data frame with the datatables IDs (phtxxxxxx) and description of your study


```R
tablesdict <- datatables.dict(JHS)
head(tablesdict)
```


<table>
<thead><tr><th scope=col>pht</th><th scope=col>dt_study_name</th><th scope=col>dt_label</th></tr></thead>
<tbody>
	<tr><td>pht002539.v2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           </td><td>Subject ID, ESP cohort, target capture used in sequencing, sequence center, race, sex, affection status, family medical history of stroke, participant medical history of asthma and COPD, ankle brachial index, artery disease status, atrioventricular block, blood pressure, body weight, height and BMI, coronary artery calcium, EKG, Framingham Risk Score, intimal-medial thickness, laboratory tests including basophils, eosinophils, neutrophils, lymphocytes, lymphocytes, blood fasting insulin and glucose, level of C-reactive protein, LDL, HDL, triglycerides, uric acid, urinary creatinine, serum creatinine, menopause, MI, FEV1, FVC, stroke status, type 2 diabetes, Wolff-Parkinson-White pattern, hormone replacement therapy, and smoking status of subjects participated in the "National Heart Lung and Blood Institute (NHLBI) GO-ESP: Heart Cohorts Component of the Exome Sequencing Project (JHS)" sub study of the "Jackson Heart Study (JHS) Cohort" project.</td></tr>
	<tr><td>pht001948.v1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>CSTA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         </td><td>Agatston score of all coronary section among participants of the Jackson Heart Study including adult 35-84 years old African Americans.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      </td></tr>
	<tr><td>pht001947.v1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>CSIA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         </td><td>Approach to life B. Life style among participants of the Jackson Heart Study including adult 35-84 years old African Americans.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              </td></tr>
	<tr><td>pht001968.v1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>PPAA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         </td><td>Post physical activity monitoring among participants of the Jackson Heart Study including adult 35-84 years old African Americans.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           </td></tr>
	<tr><td>pht001955.v1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>ECHA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         </td><td>Echocardiographic abnormalities among participants of the Jackson Heart Study including adult 35-84 years old African Americans.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             </td></tr>
	<tr><td>pht001952.v1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 </td><td>DPASS_DIET1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  </td><td>Dietary data (DPASS) among participants of the Jackson Heart Study including adult 35-84 years old African Americans.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        </td></tr>
</tbody>
</table>



#### variables.dict() will return a data frame with the variables IDs (phvxxxxxx), their name in the study, the datatable where they come from and their description


```R
vardict <- variables.dict(JHS)
head(vardict)
```


<table>
<thead><tr><th scope=col>dt_study_name</th><th scope=col>phv</th><th scope=col>var_name</th><th scope=col>var_desc</th></tr></thead>
<tbody>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00165323.v2                                                                                                                                                                                                                                </td><td>SUBJID                                                                                                                                                                                                                                        </td><td>Subject ID                                                                                                                                                                                                                                    </td></tr>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00165322.v2                                                                                                                                                                                                                                </td><td>ESP_Cohort                                                                                                                                                                                                                                    </td><td>Cohort name [JHS]                                                                                                                                                                                                                             </td></tr>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00165324.v2                                                                                                                                                                                                                                </td><td>ESP_phenotype                                                                                                                                                                                                                                 </td><td>ESP Phenotype group (phenotype that the sample was selected to be sequenced for) [EOMI_Control (Early MI control), LDL_Low, LDL_High, BP_Low (low blood pressure); BP_High (high blood pressure); DPR (Deeply Phenotyped Reference); BMI_High]</td></tr>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00181282.v1                                                                                                                                                                                                                                </td><td>Sequence_center                                                                                                                                                                                                                               </td><td>Indicates where the sample was sequence at [Broad, UW]                                                                                                                                                                                        </td></tr>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00181283.v1                                                                                                                                                                                                                                </td><td>Target                                                                                                                                                                                                                                        </td><td>Indicates target capture used in sequencing                                                                                                                                                                                                   </td></tr>
	<tr><td>ESP_HeartGO_JHS_Subject_Phenotypes                                                                                                                                                                                                            </td><td>phv00181284.v1                                                                                                                                                                                                                                </td><td>ESP_race_selfreport                                                                                                                                                                                                                           </td><td>Self report race [African American]                                                                                                                                                                                                           </td></tr>
</tbody>
</table>



Now that we have explore our datasets, let's use sandboxR in order to clean our variables, and to gather them into a tree that will be easier to use for researchers. Note that for chapter 3, we will need to move and create a lot of files on your environment. It will be easier to use on your local computer than in the Jupyterhub environment.

## 3. Extract your study
### 3.1. Export your data from dbGap
In order to get your data from dbGap, you will need to request an access and to get a decryption key. This has to be done here: https://dbgap.ncbi.nlm.nih.gov/aa/wga.cgi?login=&page=login
### 3.2. Decrypt your files
We found that the decryption system from dbGap can be tricky. We created dbgap.decrypt() in order to easily decrypt the files that you have downloaded. Note that the "files" argument can be a file or a folder containing multiple encrypted files. Also, this function works only for Mac OS at this moment.
key <- "path/to/your/key.ngc"
files <- "path/to/the/files/you/want/to/decrypt.ncbi_enc"
dbgap.decrypt(file, key)
