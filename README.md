# FinalProjectDWEDA
A final project for Data Wrangling and Exploratory Data Analysis about extracting and analyzing network data. 

# Network Performance Testing Shiny Application

## Introduction
This repository contains the source code and documentation for a Shiny application designed to perform network performance testing using Iperf. The application simplifies the process of analyzing and visualizing network performance data, making it accessible even to users without a technical background.

## Objectives
- **User-Friendly Interface**: Provide an intuitive platform for interacting with and processing Iperf test data.
- **Complex Data Interpretation**: Convert raw Iperf output into understandable visual representations and structured data tables.
- **Automation**: Automate data parsing and analysis to reduce the time and effort required for interpreting test results.

## Features
- **File Upload**: Upload text files containing Iperf test results directly into the application.
- **Data Parsing and Storage**: Automatically parse and store key performance metrics from uploaded files.
- **Data Visualization**: Generate dynamic time series and box plots for visualizing network performance.
- **Interactive Filtering**: Filter data based on specific criteria such as date ranges or network metrics.
- **Network Commands Execution**: Execute network commands and collect testing data directly from the application interface.

## Technologies Used
- **R and Shiny**: The backbone of the application, leveraging R's statistical capabilities and Shiny's web application framework.
- **ggplot2**: For creating sophisticated and visually compelling graphics.
- **DT (DataTables)**: For interactive tables within the Shiny environment.
- **httr**: For HTTP operations to manage network commands and data retrieval.

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/network-performance-testing-shiny.git
    cd network-performance-testing-shiny
    ```
2. Install required R packages:
    ```R
    install.packages(c("shiny", "ggplot2", "DT", "httr", "dplyr", "stringr", "shinythemes", "shinyWidgets"))
    ```
3. Run the Shiny application:
    ```R
    library(shiny)
    runApp("path/to/your/app")
    ```

## Usage
1. **Upload Iperf Results**: Use the file upload feature to add your Iperf test results.
2. **View Data**: The application will automatically parse and display the data in a structured format.
3. **Visualize Performance**: Utilize the dynamic plots to analyze bandwidth and other performance metrics.
4. **Filter Data**: Apply filters to focus on specific data ranges or metrics.
5. **Execute Commands**: For advanced users, execute network commands directly from the app interface.

## Project Structure
- **shiny.rmd**: Contains the main Shiny application code.
- **initialAPIParts.R**: Initial API code for handling network commands.
- **finale_with_connectors.Rmd**: Final implementation with all connectors and integration points.
- **CAP5320_Final_Presentation_Porter_Zheng.pptx**: Presentation outlining the project.
- **Final__Report_Zhi_Nicholas.docx**: Detailed project report with literature review, methodology, and results.

## Contributors
- **Zhi Zheng**: [GitHub Profile](https://github.com/ZhiZheng0889)
- **Nicholas Porter**: [GitHub Profile](https://github.com/yourpartnerusername)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- Special thanks to Dr. Feng-Jen Yang for guidance and support.
- Inspired by the need for standardized network performance testing tools.

## Contact
For any questions or suggestions, please open an issue or contact us at [your.email@example.com].


