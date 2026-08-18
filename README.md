# Point Cloud Finishing

Automates the cleanup of photogrammetric point clouds so they can be published for clients to inspect, using the CloudCompare command line instead of the GUI.

Built during a remote sensing practicum at FYBR Solutions, Vancouver BC, in May 2021\.

## What it does

Photogrammetry does not produce clean point clouds. Reconstruction from overlapping drone photos leaves stray points floating above the canopy, scattered returns along thin structures, and a low-confidence fringe at the edge of the survey area. Before this, someone removed those by hand in the GUI on every survey.

Three operations, each driven from a Windows batch file, take a raw cloud to a publishable one in a single command.

| Step | CloudCompare flag | What it does |
| :---- | :---- | :---- |
| Noise filter | `-NOISE` | Fits a local surface around each point and drops points too far from it |
| Statistical outlier removal | `-SOR` | Drops points whose mean distance to their k nearest neighbours is an outlier |
| Beauty mask | `-CROP2D` | Clips the cloud to a survey boundary polygon |

## Results on a 26.9 million point forest survey

Point counts read from the LAS headers of each output file. Each row is an independent run against the source cloud, not a cumulative pipeline, which is why every one is measured against the same 26,944,546 points.

| Stage | Points | Removed | Share of source |
| :---- | :---- | :---- | :---- |
| Source cloud | 26,944,546 |  |  |
| Noise filter, 0.4 m radius | 26,356,862 | 587,684 | 2.18% |
| Statistical outlier removal, 6 neighbours at 1 sigma | 25,662,120 | 1,282,426 | 4.76% |
| 2D crop to survey boundary | 10,408,958 | 16,535,588 | 61.37% |

Forest cloud before cleanup *Before. The fuzz standing off the canopy and below the ground surface is reconstruction noise.*

Forest cloud after statistical outlier removal *After statistical outlier removal at six neighbours and one sigma.*

The two filters are alternatives rather than steps, so you pick one. The noise filter is the conservative option, taking out roughly two points in every hundred. The statistical filter removes more than twice as many. Judged by eye the two results are close, and the noise filter gives more control at the cost of more parameters to set.

## Scripts in this repo

Each script takes the input cloud as its first argument and writes a LAS file beside it.

noise\_filter.cmd "C:\\surveys\\forestPointCloud.las"

| Script | Runs |
| :---- | :---- |
| `noise_filter.cmd` | Noise filter on its own |
| `sor_filter.cmd` | Statistical outlier removal on its own |
| `crop.cmd` | Beauty mask on its own |
| `all_steps.cmd` | Noise filter and beauty mask together |

`crop.cmd` and `all_steps.cmd` need your own boundary polygon and global shift filled in before they will run.

## Usage

The commands each script wraps, if you would rather run them directly. Requires CloudCompare 2\. LAS in, LAS out. Replace the bracketed values with your own.

### Noise filter

cd "C:\\Program Files\\CloudCompare"

CloudCompare \-O "\<path\\to\\cloud.las\>" \-C\_EXPORT\_FMT LAS \-NOISE RADIUS 0.4 REL 1.0 RIP

- `RADIUS` sets the spherical neighbourhood used to fit the local surface  
- `REL` sets the max error relative to the local spread. `ABS` takes an absolute distance instead  
- `RIP` removes isolated points

### Statistical outlier removal

cd "C:\\Program Files\\CloudCompare"

CloudCompare \-O "\<path\\to\\cloud.las\>" \-C\_EXPORT\_FMT LAS \-SOR 6 1

- First value is the number of neighbours used for the mean distance estimate  
- Second value is the standard deviation multiplier. A point is dropped when its mean distance exceeds the global mean plus this many standard deviations

Statistical Outlier Removal dialog *The same two parameters in the GUI.*

### Beauty mask

cd "C:\\Program Files\\CloudCompare"

CloudCompare \-O \-GLOBAL\_SHIFT \<easting\> \<northing\> 0 "\<path\\to\\cloud.las\>" \-C\_EXPORT\_FMT LAS \-CROP2D Z \<vertex\_count\> \<x1\> \<y1\> \<x2\> \<y2\> ...

- `-GLOBAL_SHIFT` keeps large projected coordinates within floating point precision  
- `Z` is the axis to ignore, so the polygon is applied in plan view  
- `<vertex_count>` is the number of polygon vertices, followed by each vertex as an x y pair

### Noise filter and beauty mask in one pass

cd "C:\\Program Files\\CloudCompare"

CloudCompare \-O \-GLOBAL\_SHIFT \<easting\> \<northing\> 0 "\<path\\to\\cloud.las\>" \-C\_EXPORT\_FMT LAS \-NOISE RADIUS 0.4 REL 1.0 RIP \-CROP2D Z \<vertex\_count\> \<x1\> \<y1\> ...

## Choosing parameters

Both filters need tuning to the density of the cloud you are cleaning. A sparser cloud tolerates less aggressive settings before real surface detail starts disappearing. I tuned these by running each filter and inspecting the result, so treat the values above as a starting point rather than a default.

Testing on this survey, an absolute max error produced fewer surviving stray points than a relative one, though the automation shipped with the relative setting.

## Limitations

- Parameters do not transfer between surveys flown at different densities  
- Neither filter can recover detail that photogrammetry failed to reconstruct. They only remove  
- The statistical filter has no concept of a surface, so it will trim genuine thin features such as branches and equipment railings  
- The boundary polygon is an input, not something this produces

