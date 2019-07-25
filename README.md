[![License](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](https://opensource.org/licenses/Apache-2.0)
[![DOI](https://zenodo.org/badge/153461909.svg)](https://zenodo.org/badge/latestdoi/153461909)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/gversmee/dbgap2x/)

# Using dbgap2x, R package to explore, download and decrypt phenotypic and genomic data from dbGaP

You can test this software:
- Using the dockerized version on your local device by running


```bash
docker run -p 80:8888 -v /var/run/docker.sock:/var/run/docker.sock  gversmee/dbgap2x
```

and then open your web browser at http://localhost, and use the password `dbgap2x`
- Using your local R by installing the package with


```R
install.packages("devtools")
devtools::install_github("gversmee/dbgap2x")
```

For using the package with a fresh R installation, make sure your system has the following libraries: libcurl4-openssl-dev libssl-dev libxml2-dev.
Example for a debian system:

```bash
sudo apt-get update
sudo apt-get install libcurl4-openssl-dev libssl-dev libxml2-dev -y
```


## Introduction
### Load the package


```R
#devtools::install_github("gversmee/dbgap2x", force = TRUE)
library(dbgap2x)
```

### Get the list of the function for this new package


```R
lsf.str("package:dbgap2x")
```


    browse.dbgap : function (phs, no.browser = FALSE)  
    browse.study : function (phs, no.browser = FALSE)  
    consent.groups : function (phs)  
    datatables.dict : function (phs)  
    dbgap.data_dict : function (xml, dest)  
    dbgap.decrypt : function (files, key = FALSE)  
    dbgap.download : function (krt, key = FALSE)  
    is.parent : function (phs)  
    n.pop : function (phs, consentgroups = TRUE, gender = TRUE)  
    n.tables : function (phs)  
    n.variables : function (...)  
    parent.study : function (phs)  
    phs.version : function (phs)  
    search.dbgap : function (term, no.browser = FALSE)  
    study.name : function (phs)  
    sub.study : function (phs)  
    variables.dict : function (phs)  


## Search for dbGaP studies
### Let's try to explore the "Jackson Heart Study" cohort that exists on dbGaP.
##### We created the function "browse.dbgap", which helps you to find the studies related to the term that you search for.


```R
search.dbgap("Jackson")
```

    https://www.ncbi.nlm.nih.gov/gap/?term=Jackson%5BStudy+Name%5D 
                              



<table>
<thead><tr><th scope=col>Study ID</th><th scope=col>Study Name</th><th scope=col>Release Date</th><th scope=col>Nb Participants</th><th scope=col>Study Design</th><th scope=col>Project</th><th scope=col>Diseases</th><th scope=col>Ancestor ID</th><th scope=col>Ancestor Name</th><th scope=col>Molecular Data Type</th><th scope=col>Tumor Type</th><th scope=col>UID</th></tr></thead>
<tbody>
	<tr><td>phs001356.v1.p2                                         </td><td>Exome Chip Genotyping: The Jackson Heart Study          </td><td> 2019-05-10                                             </td><td>2788                                                    </td><td>Prospective Longitudinal Cohort                         </td><td>National Heart, Lung, Blood Institute                   </td><td>Cardiovascular Diseases, Hypertension, Diabetes Mellitus</td><td>phs000286.v6.p2                                         </td><td>The Jackson Heart Study (JHS)                           </td><td>SNP Genotypes (Array)                                   </td><td>germline                                                </td><td>1692088                                                 </td></tr>
	<tr><td>phs001098.v2.p2                                                   </td><td>T2D-GENES Multi-Ethnic Exome Sequencing Study: Jackson Heart Study</td><td> 2019-05-10                                                       </td><td>1029                                                              </td><td>Case-Control                                                      </td><td>NHLBI GO-ESP                                                      </td><td>Diabetes Mellitus, Type 2                                         </td><td>phs000286.v6.p2                                                   </td><td>The Jackson Heart Study (JHS)                                     </td><td>SNP/CNV Genotypes (NGS), WXS                                      </td><td>germline                                                          </td><td>1597258                                                           </td></tr>
	<tr><td>phs000499.v4.p2                                                     </td><td>NHLBI Jackson Heart Study Candidate Gene Association Resource (CARe)</td><td> 2019-05-10                                                         </td><td>3352                                                                </td><td>Prospective Longitudinal Cohort                                     </td><td>NHLBI CARe                                                          </td><td>Longitudinal Studies                                                </td><td>phs000286.v6.p2                                                     </td><td>The Jackson Heart Study (JHS)                                       </td><td>SNP Genotypes (Array)                                               </td><td>germline, unspecified                                               </td><td>1597257                                                             </td></tr>
	<tr><td>phs000498.v4.p2                             </td><td>Jackson Heart Study Allelic Spectrum Project</td><td> 2019-05-10                                 </td><td>1983                                        </td><td>Prospective Longitudinal Cohort             </td><td>National Heart, Lung, Blood Institute       </td><td>Cardiovascular Diseases                     </td><td>phs000286.v6.p2                             </td><td>The Jackson Heart Study (JHS)               </td><td>SNP Genotypes (NGS), WXS                    </td><td>germline                                    </td><td>1597256                                     </td></tr>
	<tr><td>phs000286.v6.p2                                                                                                                                                                                       </td><td>The Jackson Heart Study (JHS)                                                                                                                                                                         </td><td> 2019-05-10                                                                                                                                                                                           </td><td>3889                                                                                                                                                                                                  </td><td>Prospective Longitudinal Cohort                                                                                                                                                                       </td><td>National Heart, Lung, Blood Institute, NHLBI GO-ESP, NHLBI CARe                                                                                                                                       </td><td>Cardiovascular Diseases, Coronary Artery Disease, Diabetes Mellitus, Type 2, Obesity, Hypertension, Kidney Failure, Chronic, Stroke, Heart Failure, Peripheral Vascular Diseases, Arrhythmias, Cardiac</td><td>                                                                                                                                                                                                      </td><td>                                                                                                                                                                                                      </td><td>                                                                                                                                                                                                      </td><td>germline, unspecified                                                                                                                                                                                 </td><td>1597254                                                                                                                                                                                               </td></tr>
	<tr><td>phs000964.v3.p1                                         </td><td>NHLBI TOPMed: The Jackson Heart Study                   </td><td> 2018-05-18                                             </td><td>3596                                                    </td><td>Prospective Longitudinal Cohort                         </td><td>National Human Genome Research Institute                </td><td>Cardiovascular Diseases, Hypertension, Diabetes Mellitus</td><td>                                                        </td><td>                                                        </td><td>SNP/CNV Genotypes (NGS), WGS                            </td><td>germline                                                </td><td>1768620                                                 </td></tr>
</tbody>
</table>



##### dbGaP returns the list of the studies related to your term. As you see, there are 6 studies associated with the "Jackson Heart Study" (JHS). One of these study is the main one a.k.a the "parent study", whereas the other ones are substudies. In this case, phs000286.v5.p1 is the parent study. Firslty, we can use the phs.version() function in order to be sure that this is the latest version of the study. We can abbreviate the phs name by giving just the digit, or we can use the full dbGaP id.


```R
phs.version("286")
```


'phs000286.v6.p2'


##### The is.parent() function is usefull to test if a study is a parent study or a substudy


```R
is.parent("000286") # JHS main cohort
is.parent("phs499") # substudy "CARe" for JHS
```


TRUE



FALSE


##### If you don't know the parent study of a substudy, try parent.study()


```R
parent.study("phs000499")
```


<ol class=list-inline>
	<li>'phs000286.v6.p2'</li>
	<li>'Jackson Heart Study (JHS) Cohort'</li>
</ol>



##### On the other side, use sub.study() to get the name and IDs of the substudies from a parent one


```R
sub.study("286")
```


<table>
<thead><tr><th scope=col>phs</th><th scope=col>name</th></tr></thead>
<tbody>
	<tr><td>phs001356.v1.p2                                                     </td><td>Exome Chip Genotyping: The Jackson Heart Study                      </td></tr>
	<tr><td>phs000498.v4.p2                                                     </td><td>Jackson Heart Study Allelic Spectrum Project                        </td></tr>
	<tr><td>phs001069.v1.p2                                                     </td><td>MIGen_ExS: JHS                                                      </td></tr>
	<tr><td>phs000402.v4.p2                                                     </td><td>NHLBI GO-ESP: Heart Cohorts Exome Sequencing Project (JHS)          </td></tr>
	<tr><td>phs000499.v4.p2                                                     </td><td>NHLBI Jackson Heart Study Candidate Gene Association Resource (CARe)</td></tr>
	<tr><td>phs001098.v2.p2                                                     </td><td>T2D-GENES Multi-Ethnic Exome Sequencing Study: Jackson Heart Study  </td></tr>
</tbody>
</table>



##### If you want to get the name of a study from its dbGaP id, use study.name()


```R
study.name("286")
```


'Jackson Heart Study (JHS) Cohort'


##### Finally, you can watch your study on dbGaP with browse.dbgap().
##### If a website exists for this study, you can browse it using browse.study()


```R
browse.dbgap("286", no.browser = TRUE)
browse.study("286", no.browser = TRUE)
```


'https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs000286.v6.p2'



'https://www.jacksonheartstudy.org'


## Explore the characteristics of your study
##### For each dbGaP study, there can be multiple consent groups that will have there specificities. Use consent.groups to know the number and the name of the consent groups in the study that you are exploring. Let's keep focusing on JHS.


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
	<tr><td>HMB-IRB       </td><td>2409          </td><td>3046          </td><td>5885          </td></tr>
	<tr><td>HMB-IRB-NPU   </td><td> 265          </td><td> 511          </td><td> 883          </td></tr>
	<tr><td>DS-FDO-IRB-NPU</td><td>  63          </td><td> 109          </td><td> 201          </td></tr>
	<tr><td>HMB-IRB       </td><td> 793          </td><td>1249          </td><td>2289          </td></tr>
	<tr><td>DS-FDO-IRB    </td><td> 174          </td><td> 295          </td><td> 516          </td></tr>
	<tr><td>TOTAL         </td><td>3704          </td><td>5210          </td><td>9774          </td></tr>
</tbody>
</table>




9774


##### Use n.tables() and n.variables() to get the number of datatables in your study and the total number of variables


```R
n.tables(JHS)
n.variables(JHS)
```


112



4856


##### datatables.dict() will return a data frame with the datatables IDs (phtxxxxxx) and description of your study


```R
tablesdict <- datatables.dict(JHS)
head(tablesdict)
```


<table>
<thead><tr><th scope=col>pht</th><th scope=col>dt_study_name</th><th scope=col>dt_label</th></tr></thead>
<tbody>
	<tr><td>pht008811.v1                                                                                                                                                                                                                                                                                                                                                                                          </td><td>MIGen_JHS_AA_Subject_Phenotypes                                                                                                                                                                                                                                                                                                                                                                       </td><td>Subject ID, age, sex, cohort, consortium, T2D affection status, weight, BMI, waist circumference, height, LDL, HDL, total cholesterol, blood pressure, adiponectin, debates age, creatinine, fasting glucose, fasting insulin, HbA1C, leptin, triglycerides, and medication of participants involved in the "Myocardial Infarction Genetics Exome Sequencing Consortium: Jackson Heart Study" project.</td></tr>
	<tr><td>pht008783.v1                                                                                                                                                                                                                                                                                                                                                                                          </td><td>sbpc                                                                                                                                                                                                                                                                                                                                                                                                  </td><td>sbpc                                                                                                                                                                                                                                                                                                                                                                                                  </td></tr>
	<tr><td>pht008727.v1                                                                                                                                                                                                                                                                                                                                                                                          </td><td>allevthf                                                                                                                                                                                                                                                                                                                                                                                              </td><td>allevthf                                                                                                                                                                                                                                                                                                                                                                                              </td></tr>
	<tr><td>pht001959.v2                                                                                                                                                                                                                                                                                                                                                                                          </td><td>loca                                                                                                                                                                                                                                                                                                                                                                                                  </td><td>loca                                                                                                                                                                                                                                                                                                                                                                                                  </td></tr>
	<tr><td>pht001945.v2                                                                                                                                                                                                                                                                                                                                                                                          </td><td>cena                                                                                                                                                                                                                                                                                                                                                                                                  </td><td>cena                                                                                                                                                                                                                                                                                                                                                                                                  </td></tr>
	<tr><td>pht001957.v2                                                                                                                                                                                                                                                                                                                                                                                          </td><td>hcaa                                                                                                                                                                                                                                                                                                                                                                                                  </td><td>hcaa                                                                                                                                                                                                                                                                                                                                                                                                  </td></tr>
</tbody>
</table>



##### variables.dict() will return a data frame with the variables IDs (phvxxxxxx), their name in the study, the datatable where they come from and their description


```R
vardict <- variables.dict(JHS)
head(vardict)
```


<table>
<thead><tr><th scope=col>dt_study_name</th><th scope=col>phv</th><th scope=col>var_name</th><th scope=col>var_desc</th></tr></thead>
<tbody>
	<tr><td>MIGen_JHS_AA_Subject_Phenotypes                                                                                                                                                                                       </td><td>phv00404354.v1                                                                                                                                                                                                        </td><td>SUBJECT_ID                                                                                                                                                                                                            </td><td>De-identified Subject ID                                                                                                                                                                                              </td></tr>
	<tr><td>MIGen_JHS_AA_Subject_Phenotypes                                                                                                                                                                                       </td><td>phv00404355.v1                                                                                                                                                                                                        </td><td>sex                                                                                                                                                                                                                   </td><td>Gender of participant                                                                                                                                                                                                 </td></tr>
	<tr><td>sbpc                                                                                                                                                                                                                  </td><td>phv00403830.v1                                                                                                                                                                                                        </td><td>SUBJECT_ID                                                                                                                                                                                                            </td><td>PARTICIPANT ID [Visit 1] [Sitting Blood Pressure Form, SBP]                                                                                                                                                           </td></tr>
	<tr><td>sbpc                                                                                                                                                                                                                  </td><td>phv00403831.v1                                                                                                                                                                                                        </td><td>VISIT                                                                                                                                                                                                                 </td><td>CONTACT OCCASION [Visit 1] [Sitting Blood Pressure Form, SBP]                                                                                                                                                         </td></tr>
	<tr><td>sbpc                                                                                                                                                                                                                  </td><td>phv00403832.v1                                                                                                                                                                                                        </td><td>SBPC1                                                                                                                                                                                                                 </td><td>Q1. A. Temperature. Room temperature (degrees centigrade) [Visit 1] [Sitting Blood Pressure Form, SBP]                                                                                                                </td></tr>
	<tr><td>sbpc                                                                                                                                                                                                                  </td><td>phv00403833.v1                                                                                                                                                                                                        </td><td>SBPC2                                                                                                                                                                                                                 </td><td>Q2. B. Tobacco and caffeine use, physical activity, and medication. Have you smoked or used chewing tobacco, nicotine gum or snuff today or do you wear a nicotine patch? [Visit 1] [Sitting Blood Pressure Form, SBP]</td></tr>
</tbody>
</table>



## Extract your study
### Get your dbGaP repository key
In order to download or decrypt your data from dbGaP, you will need to request an access and to get a decryption key. Follow those steps to access your dbGaP repository key:
##### - Go to https://www.ncbi.nlm.nih.gov/gap and click on `controlled access data`

##### - Click on Log in to dbGaP

##### - Identify yourself with your era common ID and password

##### - Get a PI dbGaP repository key:
   In order to download the files and to decrypt them, you will need a decryption key. This key can be found on a PI dbGaP account. Go to the `Authorized Access` and then `My Projects` tabs. Then, in the column `Actions` on the right of your screen, find `Get no password dbGaP repository key`.

### Decrypt the .ncbi_enc files
On dbGaP, the phenotypic files are encrypted. We created a decryption function that uses a dockerized version on sratoolkit. To use that function, you need to have docker installed on your device (www.docker.com). If you are using the dockerized version of this software (available at hub.docker.com/r/gversmee/dbgap2x), docker is already pre-installed, but you'll need to upload your key on the jupyter working directory.


```R
key <- "path/to/your/key.ngc"
files <- "path/to/directory/ofencrypted_files"
dbgap.decrypt(files, key)
```

You should see a "decrypted_files" directory in the directory where your encrypted files are located

### Download dbGaP files
##### - Click on "file selector"
This gives you access to the dbGaP file selector where you can find all the files available for the selected project. To find it, go to the `Authorized Access` and then `My Projects` tabs. Then, in the column `Actions` on the right of your screen, find `file selector`.

##### - Filter by study accession
Here, we want to get the phenotypic data for the study "Early onset COPD", so after checking `Study accession`, we select "phs000946".

##### - Filter again
Since we are only interested in getting the phenotypic data, let's filter by `Content type` and select `phenotype individual-auxiliary` and `phenotype individual-traits`.

##### - Select the files
Click on "+" to select all the files.

##### - Click on "Cart file"
This will downlaod a .krt file in your download folder.

### Download and decrypt the files


```R
key <- "path/to/your/key.ngc"
cart <- "path/to/your/cartfile.krt"
dbgap.download(cart, key)
```

You should see in your working directory a new folder named dbGaP-*** that contains your files

