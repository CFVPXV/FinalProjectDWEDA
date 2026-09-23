# Network Performance Testing with R and Shiny

Final project for Data Wrangling and Exploratory Data Analysis (CAP5320) by Zhi Zheng and Nicholas Porter. The project explores parsing iPerf network measurements, collecting repeated tests between nodes, and comparing throughput across distances using R and Shiny.

**Status:** this repository contains coursework prototypes, not a ready-to-run application. The notebooks include incomplete modules and wiring issues, and the backend required by the connector notebook is not included. Read the limitations below before attempting live tests.

## Repository contents

| File | Purpose |
| --- | --- |
| [finale_with_connectors.Rmd](finale_with_connectors.Rmd) | Most developed notebook: HTTP test collection, trial and distance metadata, raw and mean data tables, throughput plots, box plots, and one-way ANOVA code. |
| [shiny.rmd](shiny.rmd) | Earlier file-upload prototype with an iPerf text parser, filtering, time-series modules, and unfinished trial-spread and SCP modules. |
| [initialAPIParts.R](initialAPIParts.R) | Early Plumber API sketch for invoking `iperf3`; requires implementation work before use. |
| [shiny.nb.html](shiny.nb.html) | Saved HTML notebook preview; open locally in a browser to inspect it without running R. It does not start a live Shiny session. |
| [CAP5320_Final_Presentation_Porter_Zheng.pptx](CAP5320_Final_Presentation_Porter_Zheng.pptx) | Project presentation. |
| Four PDF files in the repository root | Background reading on iPerf, software-defined networking/QoS, and high-throughput networking. |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution workflow. |
| [CHANGELOG.md](CHANGELOG.md) | Recorded maintenance changes. |

There is no standalone `app.R`, dependency lockfile, sample measurement dataset, or automated test suite in the repository.

## Setup

Install R and, for interactive notebook work, RStudio. No R or package versions are pinned.

Clone the repository from a terminal:

```sh
git clone https://github.com/ZhiZheng0889/FinalProjectDWEDA.git
cd FinalProjectDWEDA
```

In an R console, set the working directory to the cloned repository and install the notebook dependencies:

```r
install.packages(c(
  "shiny", "DT", "tidyverse", "stringr", "shinythemes", "rlang",
  "httr", "shinyWidgets", "rstatix", "rmarkdown", "knitr"
))
```

`tidyverse` supplies packages used by the parsing and plotting code, including `dplyr`, `purrr`, `tibble`, and `ggplot2`. Install `plumber` separately only if working on `initialAPIParts.R`. Live network collection also requires iPerf3 and a compatible HTTP service on the test nodes; neither is bundled here.

## Working with the notebooks

Open `finale_with_connectors.Rmd` in RStudio to explore the connector version, or `shiny.rmd` to inspect the upload prototype. Run chunks in order to load dependencies, define the parser and modules, and construct the UI and server. Both notebooks define `ui` more than once; the last definition is used by the final `shinyApp(ui, server)` call.

After addressing the relevant limitations below, run the final chunk to launch the app. To launch the connector notebook from an R console instead, extract its code to a temporary script and explicitly run its UI/server pair:

```r
app_script <- tempfile(fileext = ".R")
knitr::purl("finale_with_connectors.Rmd", output = app_script, quiet = TRUE)
source(app_script)
shiny::runApp(shiny::shinyApp(ui = ui, server = server))
```

This executes the existing code; it does not fix the prototype's errors. The files are HTML notebooks rather than documents configured with `runtime: shiny`, so previewing a notebook is not a substitute for launching the app. Use RStudio's Stop button or interrupt the R console to stop the server.

### Inspecting the parser without a backend

Run only the dependency chunk, the `isDataLine` chunk, and the chunk defining the conversion helpers and `parseLine` in either notebook. Then try:

```r
parseLine("[  5]   0.00-1.00   sec  1.00 MBytes  8.00 Mbits/sec  0  64 KBytes")
```

This should produce one row with `IntervalStart = 0`, `IntervalEnd = 1`, `Transfer(KB) = 1000`, `Bitrate(Kbps) = 8000`, `Retr = 0`, and `Cwnd = 64`.

The parser accepts iPerf-style interval text for **stream ID 5 only**, with decimal interval boundaries. It excludes sender/receiver summaries and completion lines. The upload and HTTP ingestion code also converts literal `\n` sequences into line breaks. It does not implement an iPerf JSON parser.

| Parsed column | Meaning |
| --- | --- |
| `IntervalStart`, `IntervalEnd` | Interval boundaries in seconds. |
| `Transfer(KB)` | Transfer size converted using the code's decimal K/M/G multipliers. |
| `Bitrate(Kbps)` | Bitrate converted to kilobits per second. |
| `Retr` | Retransmissions, or `NA` when absent. |
| `Cwnd` | Congestion window converted to KB, or `NA` when absent. |

The live collector adds `trial` and `distance_in_feet`. The conversion helpers use factors of 1,000 and 1,000,000; bare `Bytes` and `bits/sec` fall through unchanged, so those inputs are not correctly normalized to the labeled kilo-units.

### Intended live-test workflow

The connector notebook expects services reachable from the computer running R on HTTP port **8000**:

| Node | Request | Expected role |
| --- | --- | --- |
| Server | `POST /start_server` | Start the iPerf server. |
| Client | `POST /start_tests?nodeNameOne=<server-name>` | Run a test against the selected server. |
| Client | `GET /get_results` | Return iPerf interval text that the parser can consume. |

These routes are called sequentially for each trial. The code immediately retrieves results after the test request, so the backend must make completed results available at that point. The repository does not provide these routes or instructions for deploying that backend; `initialAPIParts.R` exposes a different, unfinished route.

Once the backend and notebook issues are resolved:

1. Enter reachable server and client hostnames or IP addresses in the sidebar, without a URL scheme or port.
2. Enter a positive integer test count and the distance between nodes in feet. Distance is a manually supplied label, not a measured value.
3. Select **Start Iperf** to collect trials and update the progress bar.
4. Inspect **Raw Data**, **Mean of Trials**, **Time Series Visualization**, and **Box Plot of Trials**. The connector's time-series plot shows mean bitrate by trial, colored by distance.
5. Collect measurements at multiple distances to support the intended **One Way ANOVA** comparison.

The upload prototype is intended to read a `.txt` file, apply a numeric filter, and display the filtered table and interval plot. Its table and plot depend on clicking **Filter Data**. The connector notebook still displays a file chooser, but its upload handler is commented out, so selecting a file there does not populate the analysis.

## Known implementation limitations

- **Upload prototype:** `shiny.rmd` references undefined `trialsSpreadUI` and `trialsSpreadModule` functions. Its final table output ID also differs from the module's namespaced output ID. These prevent the advertised workflow from working as written.
- **Filtering:** the selector includes `Transfer(Bits)` although the parser creates `Transfer(KB)`, and its default bitrate selection is misspelled. Dynamically generated filter controls are not mounted in the UI. Filtering uses numeric intervals, not dates.
- **Connector wiring:** `finale_with_connectors.Rmd` retains a time-series module call referencing undefined `storedData`, while its final UI uses a separate plot output. The collector appends to `dat$interdat` instead of `dat$inter_dat`, so raw data does not accumulate as intended.
- **Trial summaries:** `summarize_trials()` assigns the full raw distance vector after grouping into fewer rows, which can cause a size mismatch when trials contain multiple intervals.
- **ANOVA:** the result is created only when at least two distance groups exist, but the output attempts to display it even when it has not been created.
- **API sketch:** `initialAPIParts.R` declares `GET /run_and_collect`, calls a zero-argument function with an argument, references undefined configuration variables, and does not start an API listener. It is not the backend expected by the connector notebook.
- **SCP:** transfer functions reference unimplemented `sanitizeHost` and `sanitizePath` helpers and are not exposed in the final interfaces.

Treat the notebooks as starting points for completing and validating the workflow. Network calls do not check HTTP status or poll for completion, and collected data is held in memory without an implemented export feature.

## Contributors and maintenance

- [Zhi Zheng](https://github.com/ZhiZheng0889)
- [Nicholas Porter](https://github.com/CFVPXV)

Thanks to Dr. Feng-Jen Yang for guidance and support. See [CONTRIBUTING.md](CONTRIBUTING.md) for proposing changes and [CHANGELOG.md](CHANGELOG.md) for maintenance history.

No license file is included in this repository.
