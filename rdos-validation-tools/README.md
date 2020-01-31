#### Create RDO Validation Java jar
mvn -pl rdo-validation-tool-java/ -am clean package

#### Create RDO Validation Scala jar
mvn -pl rdo-validation-tool-scala/ -am clean package

#### Compile the project
mvn clean compile

#### Run the jar
java -jar <jar_name> <validation_type> <directory_path_for_files> <output_directory_path_for_errors>

Here, <output_directory_path_for_errors> is optional. If it will not be given then the <directory_path_for_files> will be used to create error files.








