# **EDM2RDO Tool** #

The EDM2RDO (V1.0) tool is a companion to the RDOS SQL specification that aids in the conversion of EDM data to RDOS specific format. This tool is a reference implemenation.

## **Prerequisites** ##

Microsoft SQL Server with dbo privileges  - This can be either a local instance or a remote instance. You need an account with dbo or sa privilages.

SQL Server Management Studio or Azure Data Studio (for Linux and MacOS) for interacting with SQL Server.

NET Core - Install the latest version of [.NET Core SDK](https://dotnet.microsoft.com/download) and ensure version 2.2 is installed (Optional)

## **Installation** ###

Download and unzip the tool in a folder on your computer.

[Windows 64-bit](https://rmsimport.blob.core.windows.net/public/Edm2Rdos_V1/edm2rdo-win-x64.zip)

[MacOS 64-bit](https://rmsimport.blob.core.windows.net/public/Edm2Rdos_V1/edm2rdo-osx-x64.zip)

[Ubuntu 64-bit](https://rmsimport.blob.core.windows.net/public/Edm2Rdos_V1/edm2rdo-ubuntu-x64.zip)

## **Running the tool** ###

To use the tool, you need to provide and input connection string (EDM database) and an output connection string (expected new RDO database).
You can download [EDM_Sample](https://rmsimport.blob.core.windows.net/public/Edm2Rdos_V1/Edm2Rdos_Sample.zip) database to use with the tool.  The examples below show how to run the tool using the included sample database.

You can run the tool without any parameters and it will list the options.

On Mac and Linux

```bash
chmod +x Edm2Rdo   # Make the file executable 
./Edm2Rdo
```

On Windows

```dos
Edm2Rdo
```

## **Notes** ###

* The tool requires a source EDM database in Microsoft SQL Server. Sample scripts with data and reference tables are provided [here](../schema/sql) or you can use the sample database provided above to use the tool.

* The tool go through the process of extracting the accounts and efficiently transform this into RDOS schema.
Depending on the parameters that you specify the output can be either to a SQL in the same DB or a different DB, CSV file or parquet file.
There are a few more options like specifying peril precedence , excluding the lookup tables and custom directory for outputting the csv or parquet files.

* Links for docker images for Microsoft SQL Server (for Mac or Linux).
    Install [Docker Desktop](https://www.docker.com/products/docker-desktop) for your OS and download official images for [SQL Server 2017](https://hub.docker.com/_/microsoft-mssql-server) on Linux for Docker Engine. Make sure you use '2017-latest-ubuntu' docker image for SQL Server. You can follow the instructions [here](https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-2017) to restore the downloaded sample database in docker.
* If you are running on Windows you can download SQL Server Express and use SSMS to restore the database.

### **How to use the tool** ###

The only required parameter for Edm2Rdo tool is -i or --input-connection. The tool will create a new **RDO** schema. If you have run the tool once, make sure you drop the **RDO** schema before running the tool again.

```bash
./Edm2Rdo -i  "Data Source=(local);Database=<EDM_Database_Name>;User Id=<your dbo or sa user id>;Password=<your-password>"
```

When -o or --output-connection parameter is provided, the tool will create a new **RDOS** database. If you have run the tool once, make sure you drop the **RDO** database before running the tool again.

```bash
./Edm2Rdo -i  "Data Source=(local);Database=<EDM_Database_Name>;User Id=<your dbo or sa user id>;Password=<your-password>" -o "Data Source=(local);Database=rdo;User Id=<your dbo or sa user id>;Password=<your-password>"
```

The output format can be specified with --format and --directory for the location of output files. Available options for format are sql, csv and parquet.

```bash
./Edm2Rdo -i  "Data Source=(local);Database=<EDM_Database_Name>;User Id=<your dbo or sa user id>;Password=<your-password>" --directory <your local path> --format csv
```

The default peril precedence can we overriden by providing a peril precedence file in json format using -f or --peril-precedence-file-path.

```bash
./Edm2Rdo -i  "Data Source=(local);Database=<EDM_Database_Name>;User Id=<your dbo or sa user id>;Password=<your-password>" -f <local path to peril precedence file>
```

An example of peril precedence file is shown below:
Save this file as a .json file and pass the parameter -f with the path to the file.

```json
[
    {
        "US": [ "WS", "EQ", "FL", "FR", "TO", "TR" ],

        "AU": [ "EQ", "WS", "TO", "TR", "FR", "FL" ]
    }
]
```

For SQL Express users: You must specify the data source as `(local)\sqlexpress` (with one backslash for PowerShell, two for Dos) and you can use Windows authentication as shown below:

DOS:

```dos
Edm2Rdo -i  "Data Source=(local)\\sqlexpress;Initial Catalog=<EDM_Database_Name>;Trusted_Connection=True" -o "Data Source=(local)\\sqlexpress;Database=rdo;Trusted_Connection=True" (one backslash for PowerShell)
```

PowerShell:

```powershell
./Edm2Rdo -i  "Data Source=(local)\sqlexpress;Initial Catalog=<EDM_Database_Name>;Trusted_Connection=True" -o "Data Source=(local)\sqlexpress;Database=rdo;Trusted_Connection=True" (one backslash for PowerShell)
```

Remote source and local destination.

```dos
Edm2Rdo -i  "Data Source=<remote data source>;Database=<EDM_Database_Name>;User Id=rmsuser;Password=<your-password>" -o "Data Source=(local);Database=rdo;User Id=<your dbo or sa user id>;Password=<your-password>"
```

## **Known Issues** ##

* If output is other than SQL a directory for the output file must be provided else you'll see an error. This will be improved in the final version.
