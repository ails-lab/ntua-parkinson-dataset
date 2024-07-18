# The NTUA Parkinson Dataset

This dataset currently consists of MRI examinations and DaT Scans from a total of 78 individuals, 55 of which are suffering from Parkinson's Disease, while 23 serve as normal control subjects.

## Imaging data

The images are split into two folders based on their diagnosis (PD for patients suffering from Parkinson's Disease and NPD for control subjects). 

A total of over 42000 images are available for academic use.

Image type | PD | NPD | Total
--- | --- | --- | ---
DaT scan | 590 | 330 | 920
MRI | 32706 | 10381 | 43087

## Descriptive data

Besides the medical images, some other information is also available about several of the subjects. Namely demographics (date of birth, sex), clinical information (disease duration, date of first diagnosis), medication and test scores. These can be found in CSV format inside the PD/NPD folders. The first column 'alias' refers to the subject id from the folder name.

Note that not all information is available for all of the subjects!

## Citing the work

If you plan to use this dataset in your research, please cite:

<pre>
@article{tagaris2018machine,
  title={Machine Learning for Neurodegenerative Disorder Diagnosis—Survey of Practices and Launch of Benchmark Dataset},
  author={Tagaris, Athanasios and Kollias, Dimitrios and Stafylopatis, Andreas and Tagaris, Georgios and Kollias, Stefanos},
  journal={International Journal on Artificial Intelligence Tools},
  volume={27},
  number={03},
  pages={1850011},
  year={2018},
  publisher={World Scientific}
}
</pre>
