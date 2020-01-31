### RDO Validation Tool
This project validates the RDOS input files (CSV Format) and the CDL files.

It validates RDOS input files for the 2 following things:
* Data Type Validation
* Integrity Constraint Validation (Primary and foreign key)

It accepts 2 validation types:
* RDOS: For RDOS input files
* CDL: For CDL files

#### Compile the project
mvn clean compile

#### Create a project jar
mvn clean package

#### Run test cases with coverage report
mvn clean scoverage:report

#### Run the jar
java -jar <jar_name> <validation_type> <directory_path_for_files> <output_directory_path_for_errors>

Here, <output_directory_path_for_errors> is optional. If it will not be given then the <directory_path_for_files> will be used to create error files.
