# Camera-Based River Surface Velocity and Discharge Estimation using Deep Optical Flow

## Overview
This repository contains the implementation used to estimate river surface velocity and discharge from video imagery using deep optical flow models. Surface velocities are extracted from video frames and combined with surveyed bathymetry and water stage measurements to compute river discharge.

The workflow follows the methodology described in the associated *Journal of Hydrology* manuscript.

## Features
- Surface velocity estimation using deep optical flow models  
- Cross-section velocity extraction  
- Depth-averaged velocity conversion  
- Lateral profile reconstruction  
- Corrected and uncorrected discharge estimation  

## Repository Structure
- `notebooks/` – Jupyter notebooks for each optical flow model (FlowFormer++, MaskFlowNet, and LiteFlowNet2)  
- `model_setup/` – Setup scripts to create virtual environments and install dependencies  
- `survey_data/` – GCP surveys for each site and cross-section bathymetry data  
- `radar_camera_intersection/` – Notebook for finding the intersection of camera and radar measurements   

Example videos for each site can be downloaded from [Google Drive](https://drive.google.com/drive/folders/1ggGK6mhFYr_91fxth_Dvx8Fs6ZIPzimE?usp=sharing). Pre-trained weights can be obtained from the official MMFlow and FlowFormer++ repositories, or the specific models we used are also available from [Google Drive](https://drive.google.com/drive/folders/1Xb3SpEO93qgkpFhfsgcQPuuo7AKwTawH?usp=drive_link).  

## Requirements
To run the notebooks and reproduce results, your system should meet the following requirements:

- **Python**: 3.8 or higher  
- **PyTorch**: 1.12+ with CUDA support for GPU acceleration (CUDA 11.6 recommended)  
- **Torchvision** and **Torchaudio** compatible with the PyTorch version  
- **OpenCV** (cv2) for video and image processing  
- **NumPy**, **SciPy**, and **Pandas** for numerical computations and data handling  
- **Matplotlib** for visualization  
- **TQDM** for progress bars  
- **MMFlow** library (for MaskFlowNet and LiteFlowNet2 models)  
- **FlowFormer++** (for FlowFormer models)  
- **MMEngine** and **MMCV** dependencies for MMFlow integration  
- **Jupyter Notebook** (optional, for interactive use)

## Inference / Testing Instructions
1. Select a GPU for processing, as video inference requires significant resources.  
2. Run the setup scripts (`setup_mmflow.sh` for MMFlow models or `setup_flowformer.sh` for FlowFormer++). These scripts will create a virtual environment and install all required dependencies.  
3. Download the videos and pre-trained models. If reproducing our results, use the Google Drive links provided.  
4. Use the site-specific data provided in `Survey_data/`, including GCPs and cross-section bathymetry.  
5. Run the notebooks to start the workflow:  
   - Step 1: Compute surface velocity from video frames.  
   - Step 2: Extract cross-section surface velocities at surveyed points and visualize them.  
   - Step 3: Convert surface velocity to depth-averaged velocity using the site-specific conversion factor (we used 0.9).  
   - Step 4: Reconstruct lateral profiles and fill missing values using a power-law method. The shape of the profile is controlled by the alpha factor, which can be adjusted per site.  
   - Step 5: Calculate discharge using \(Q = A \times V\), where \(A\) is cross-section area (calculated from bathymetry and stage), and \(V\) is the mean velocity. For each video, provide the water stage to compute depth, then calculate the area segment by segment using the cross-section survey and combine with the velocity to get discharge. If reference ground truth is available, compute error metrics such as MAE and percent error.  
6. You can switch models depending on your needs:  
   - FlowFormer++ provides the most accurate results but has the highest processing time.  
   - MaskFlowNet is the most balanced choice in terms of accuracy and processing speed.  
   - LiteFlowNet2 is highly efficient and suitable for low-resource environments.  

## References
- FlowFormer++: [GitHub Repository]((https://github.com/XiaoyuShi97/FlowFormerPlusPlus))  
- MMFlow library: [GitHub Repository](https://github.com/open-mmlab/mmflow)

## Funding and Acknowledgments
This research was supported by the Cooperative Institute for Research to Operations in Hydrology (CIROH) with joint funding under award NA22NWS4320003 from the NOAA Cooperative Institute Program and the U.S. Geological Survey. The statements, findings, conclusions, and recommendations are those of the author(s) and do not necessarily reflect the opinions of NOAA or USGS. Utah State University is a founding member of CIROH and receives funding under subaward from the University of Alabama. Additional support has been provided by the Utah Water Research Laboratory at Utah State University.
