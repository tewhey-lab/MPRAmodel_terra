# MPRAmodel

#### Part 3 of the MPRAsuite (of 3)
This fork is designed to facilitate the running of this pipeline on Terra.bio. To run the pipeline locally please see the original branch of the repository.


MPRAmodel.R:
      A series of functions to assist in analysis of MPRA count tables


## Arguments

### There are 3 files that this pipeline needs for input. <br>
   * `countsTable` : Table of counts with header. Should be either the output of the [MPRAcount](https://github.com/tewhey-lab/tag_analysis_WDL) pipeline, or in the same format. <br>
   * `attributesData` : Attributes for each oligo including oligo name, SNP, chromosome, position, reference allele, alt allele, Allele (ref/alt), window, strand, project, haplotype. For Oligos named in the form chr:pos:ref:alt:allele:window(:haplotype) the scripts [here](https://github.com/tewhey-lab/tag_analysis_WDL/blob/master/scripts/make_infile.py) and [here](https://github.com/tewhey-lab/tag_analysis_WDL/blob/master/scripts/make_attributes_oligo.pl) can be used to generate the attributes table. <br>
   * `conditionData` : 2 columns w/no header column 1 is replicates as found in the count table, column 2 indicates cell type. This can be done in the program of your choice, or taken from the output of [MPRAcount](https://github.com/tewhey-lab/tag_analysis_WDL).

### Other arguments needed <br>
  * `filePrefix` : STRING; All written files will have this string included in the file name, if running the pipeline multiple times with  different settings this is a good place to differentiate them
  * `plotSave` : LOGICAL; Default `TRUE`, indicator of whether or not to save non-normalization QC plots
  * `altRef` :  LOGICAL; Default `TRUE`, indicator of how to sort alleles for `cellSpecificTtest`
  * `method` : STRING; Default "ss", indicator of method to be used to normalize the data
      * `'ss'` : Summit Shift - shifts the l2fc density peak to line up with 0
      * `'ssn'` : Summit Shift (Negative Controls Only) - shifts the peak of negative controls to 0
      * `'ro'` : Remove outliers - remove oligos that don't have a p-value or have a p-value > 0.001
      *`'nc'` : Negative Controls - normalize only the negative controls
  * `negCtrlName` : STRING; Default "negCtrl", how negative controls are indicated in the project column of the `attributesData` file
  * `posCtrlName` : STRING; Default "expCtrl", how positive controls are indicated in the project column of the `attributesData` file
  * `projectName` : STRING; Default "MPRA_PROJ", a generalized name for the overall project
  * `tTest` : LOGICAL; Default `TRUE`, perform cell type specific tTest to determine emVARs
  * `DEase` : LOGICAL; Default `TRUE`, use Differential Expression methods to detect Allele Specific Expression (this method can be found [here](http://rstudio-pubs-static.s3.amazonaws.com/275642_e9d578fe1f7a404aad0553f52236c0a4.html))
  * `correction` : STRING; Default "BH", indicator of whether to use Benjamini Hochberg ("BH") or Bonferroni ("BF") for p-value correction
  * `cutoff` : INT; Default 0.01, significance cutoff for including alleles for skew calculation (tTest only)
  * `upDisp` : LOGICAL; Default `TRUE`, update dispersions with cell type specific calculations
  * `prior` : LOGICAL; Default `FALSE`, use `betaPrior=F` when calculating the cell type specific dispersions

