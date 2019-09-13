xml_files = Channel
                  .fromPath( '/home/sturm/scratch/pubmed/xml/*.xml.gz')
                  .map { file -> [file.name.split("\\.").first(), file] }

process mine_xml_file {
  conda "beautifulsoup4"
  publishDir "results"
  cpus 1

  input:
  set id, file('pubmed.xml') from xml_files

  output:
  file "*.result.json" into results

  """
  text_mining.py 'pubmed.xml' > ${id}.result.json
  """

}
