# The NTUA Parkinson Dataset

This dataset currently consists of MRI examinations and DaT Scans from a total of 78 individuals, 55 of which are suffering from Parkinson's Disease, while 23 serve as normal control subjects.

A total of over 42000 images are available for academic use.

Image type | PD | NPD | Total
--- | --- | --- | ---
DaT scan | 590 | 330 | 920
MRI | 32706 | 10381 | 43087



To get this dataset:

```
git clone gogs@git.islab.ntua.gr:thanos/ntua_parkinson.git
```


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

## Issues:

- If you get a server certificate verification error:

```
fatal: unable to access 'https://git.islab.ntua.gr/thanos/ntua_parkinson.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
```

Do the following:  

```
git config --global http.sslverify false   
git clone https://git.islab.ntua.gr/thanos/ntua_parkinson.git   
git config --global http.sslverify true   
```
