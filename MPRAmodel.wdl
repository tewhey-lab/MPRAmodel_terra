#Pipeline for running MPRAmodel via WDL

workflow MPRAmodel {
  File count # barcode based count file (MPRAcount)
  File attributes # attributes file associated with the library
  File condition # condition table associated with the library (MPRAcount)

  Int cell_num # Number of cell types being tested

  String out_dir
  String project # library name (OLXX)
  String prefix # any alteration from standard run (ex: _negative_controls)
  String negCtrl # string indicating negative controls as indicated in the projects column of attributes table
  String posCtrl # string indicating positive controls as indicated in the projects column of attributes table

  String? docker_tag = "latest"
  String? method = 'ss' # See docs for more info
  String? correction = 'BH' # See docs for more info
  String? tTest = 'T' # See docs for more info
  String? DEase = 'T' # See docs for more info
  String? upDisp = 'T' # See docs for more info
  String? prior = 'F' # See docs for more info
  String? paired = 'F' # See docs for more info
  Float? cutoff = 0.01 # See docs for more info

  Int model_disk = ceil(size(count, "GB") + size(attributes, "GB") + 0.5*cell_num) + 1 ### calculation for the disk space needed for the project keeping in mind that we need to load files in as well as space for output files
  Int rel_disk = ceil(size(model.plots, "GB") + size(model.files, "GB"))

  call model { input:
        count = count,
        attributes = attributes,
        condition = condition,
        project = project,
        prefix = prefix,
        negCtrl = negCtrl,
        posCtrl = posCtrl,
        docker_tag = docker_tag,
        method = method,
        correction = correction,
        tTest = tTest,
        DEase = DEase,
        upDisp = upDisp,
        prior = prior,
        paired = paired,
        cutoff = cutoff,
        model_disk = model_disk
      }
  call relocate { input:
        plots_out = model.plots,
        res_out = model.files,
        out_dir = out_dir,
        docker_tag = docker_tag,
        rel_disk = rel_disk
    }

}

task model {
  File count
  File attributes
  File condition

  String project
  String prefix
  String negCtrl
  String posCtrl

  String docker_tag
  String method
  String correction
  String tTest
  String DEase
  String upDisp
  String prior
  String paired
  Float cutoff

  Int model_disk

  command <<<
    Rscript /scripts/analysis_sub_terra.R ${project} ${prefix} ${negCtrl} ${posCtrl} ${method} ${tTest} ${DEase} ${correction} ${cutoff} ${upDisp} ${prior} ${paired} ${attributes} ${count} ${condition}
  >>>
  output {
    Array[File]+ plots=glob("plots/*")
    Array[File]+ files=glob("results/*")
  }
  runtime {
    docker: "quay.io/tewhey-lab/mpramodel:${docker_tag}"
    memory: "25G"
    cpu: 8
    disks: "local-disk ${model_disk} SSD"
  }
}

task relocate {
  Array[File] plots_out
  Array[File] res_out
  Int rel_disk
  String out_dir
  String docker_tag

  command <<<
    mkdir ${out_dir}/plots
    mkdir ${out_dir}/results
    mv ${sep=' ' plots_out} ${out_dir}/plots/
    mv ${sep=' ' res_out} ${out_dir}/results/
  >>>
  runtime {
    docker: "quay.io/tewhey-lab/mpramodel:${docker_tag}
    memory: "4G"
    disks: "local-disk ${rel_disk} SSD"
  }
}
