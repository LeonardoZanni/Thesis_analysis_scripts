# C. elegans synaptic and sleep analysis scripts

This repository contains custom MATLAB and Fiji scripts used for image and behavioral analysis in my master thesis.  
Specifically, the code was used to:

- Quantify T‑piece and nerve ring synaptic marker size and intensity in C. elegans
- Measure T‑piece volume using 3D analysis in Fiji
- Compute sleep fraction during lethargus using frame subtraction and quiescence detection from long-term imaging
  
They are provided here for reproducibility and as supplementary material to the thesis.

---

## Repository structure
```plaintext

── Lethargus_substraction.m                                         # MATLAB: Extracts movement intensity traces from timelapse stacks
── Lethargus_selector.m                                             # MATLAB: Aligns data to molt time and selects time window
── Bout_detection .m and Lethargus_selector_analyzer.m                # MATLAB: Detects quiescence bouts based on speed thresholds adn calculates sleepfraction
── Analysis_synapsis_backgrounsubstraction.m                        # MATLAB: Measures GFP/RFP signal and size in T-piece & nervring
── Volume_tpiece_Analyzer.ijm                                       # Fiji macro: Measures 3D volume of the T-piece
── README.md                                                        # This file
