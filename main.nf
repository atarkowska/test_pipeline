#!/usr/bin/env nextflow

input_file = file(params.input)

Channel
    .fromPath(input_file)
    .splitCsv(header:true)
    .map{ row -> 
      def researcher = row.researcher
      def Project = row.Project
      def SlideID = row.SlideID
      tuple(researcher, Project, SlideID)
    }
    .set { ch_input }

//ch_input.view()

output_dir = file(params.output)


/*
 * test tower
 */
process testing_process {

  label "python_36"

  publishDir path: output_dir, mode: "copy"

  input:
  set researcher, project, SlideID from ch_input

  output:
  file 'test.txt'

  shell:
  result = 'result.txt'
  '''
  echo "!{researcher}, !{project}, !{SlideID}" >!{result}
  python --version >>!{result}
  '''

}

