# TownsendData
Data: refers to Townsend Household Annual data <br>
This repository includes codes for cleaning and generating simple trends <br>

## WORKFLOW
- Select only the necessary variables to reduce computer's load. (Each file contains only certain sets of variables) <br>  
- Construct individual ID for merge. Note that this ID is not consistent across year. <br>
- Merge each file together by individual ID. Drop individual ID after this. <br>

## LIST OF FILES
- combineTownsend.R: combine data by year using roster number
- province_recode.R: fix coding mistakes in province variable <br>




