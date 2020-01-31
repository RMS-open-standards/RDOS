### CDL parser
CDL syntax is defined in the grammar file antlr4/CDL.g4.
CDL Parser is generated from the CDL grammar file using the ANTLR4 parser generator. 

This library contains ContractValidator class which provides example usage of the CDL Parser.  ContractValidator is used in the RDO validation tool to validate CDL files.


###References
https://www.antlr.org/

#### Compile the project
mvn clean compile

#### Publish the jar in local maven repository
mvn clean install

#### How to use the library ?
Include the below artifact into the application's pom
 ```
    <dependency>
      <groupId>com.rms</groupId>
      <artifactId>cdl-parser</artifactId>
      <version>${cdl-parser.version}</version>
    </dependency>
```