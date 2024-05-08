# Overview
The customized scripts of the ferroptotic trigger wave analysis for image analysis, simulation, and plotting.

The provided scripts are run in MATLAB (R2023b).  
OS: Windows 10  
CPU: AMD Ryzen 9 5900X  
RAM: 32 GB 1800 MHz DDR4

## Folder description

### Figure1
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 1a and 1b  | `Figure1\long_distance\script\export.ijm` `Figure1\long_distance\script\outline.m`  | plot the outlines of ferroptotic trigger wave and export microscopic images |
| 1c  | `Figure1\long_distance\script\get_slices.m`  | plot ferroptotic trigger wave with an ROI |
| 1d  | `Figure1\long_distance\script\make_kymograph.m`  | plot the kymograph of ferroptotic trigger wave |
| 1e  | `Figure1\long_distance\script\diffusion_plot.m`  | plot the data of ferroptotic trigger wave with theoretical diffusion |
| 1f  | `Figure1\lipid_dye\script\outline_lipid.m` `Figure1\lipid_dye\script\plot_profile.m`  | plot the outlines and profile of ferroptotic trigger wave (cell death and lipid) |
| 1g  | `Figure1\lipid_dye\script\outline_cy5.m` | plot the outlines of ferroptotic trigger wave (cell death) |
| 1h  | `Figure1\lipid_dye\script\get_slices.m` | plot ferroptotic trigger wave with an ROI (cell death and lipid) |
| 1i  | `Figure1\lipid_dye\script\make_kymograph.m` | plot the kymograph of ferroptotic trigger wave |

### Figure2
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 2a | `Figure2\script\export.ijm` `Figure2\script\plot_profile.m` | the cropped images over time and plot the profile of ROS across gaps over time |
| 2b | `Figure2\script\passing_prob.m` | plot a logistic curve fitted to the gap size that can continue a wave |

### Figure3
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 3c and d | `Figure3\script\export_DFO.ijm` `Figure3\script\outline_DFO.m` `Figure3\script\make_kymograph_DFO.m`| export microscopic images and plot the outlines and kymograph of ferroptotic trigger wave of DFO |
| 3e and f | `Figure3\script\export_FAC.ijm` `Figure3\script\outline_FAC.m` `Figure3\script\make_kymograph_FAC.m` | export microscopic images and plot the outlines and kymograph of ferroptotic trigger wave of FC |
| 3g, 3h and 3i | `Figure3\script\make_kymograph.m` | plot the kymograph of ferroptotic trigger wave under the chemical perturbations (GKY, LY294002, and Dasatinib) |
| 3j to 3n | `Figure3\script\summarize_DFO_96.m` `Figure3\script\summarize_FAC_96.m` `Figure3\script\summarize_GKT_96.m` `Figure3\script\summarize_LY294002_96.m` `Figure3\script\summarize_Dasatinib_96.m`  | plot the dose-response curves of 5 chemical perturbations |

### Figure4
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 4a | `Figure4\priming\script\bifurcation_diagram.m`| Bifurcation diagram |
| 4b | `Figure4\priming\script\export_ros_steadystate.ijm`| export microscopic images (ROS) after photoinduction |
| 4c | `Figure4\priming\script\quantify_ros_staedystate.m`| plot ROS steady state before and after photoinduction |
| 4d | `Figure4\erastin6\script\sim_trigger_waves.m` `Figure4\erastin6\script\export.ijm` `Figure4\erastin6\script\outline.m` | plot simulated trigger waves, export microscopic images and plot the outlines |
| 4e to 4g | `Figure4\erastin6\script\summarize_speed.m` `Figure4\erastin6\script\measure_wavefront_width_amp.m` | plot wave speed, wavefront width, and ROS amplitude under different erastin levels |

### Figure5
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 5a and 5b | `Figure5\muscle_4hne\script\export_fig5a.ijm` `Figure5\muscle_4hne\script\export_fig5b.ijm` | export microscopic images |
| 5c and 5d | `Figure5\tunel_4hne\script\export_fig.ijm` | export microscopic images |
| 5e | `Figure5\wave_in_limb\script\processing.ijm` `Figure5\wave_in_limb\script\outline_limb.m` `Figure5\wave_in_limb\script\outline_wave.m` | export microscopic images and plot outlines |
| 5f | `Figure5\death_area\script\summarize_area.m` | plot the ratio of death area to limb area under different conditions |
| 5g to 5i | `Figure5\photoinduction\script\export_v2.ijm` `Figure5\photoinduction\script\plot_ROS_quantification_v2.m` | export microscopic images and plot quantification result |
| 5j | `Figure5\muscle_fiber\script\generate_maxprojection_subset_fiber.ijm` `Figure5\muscle_fiber\script\fiber_orientation_v2.ijm` | export fiber images with colormap representing fiber orientation|

### Extended data figure 1
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 1a, 1d, 1f, 1h | `EDF1\sytox\script\export.ijm` `EDF1\rpe_erastin\scriptexport_for_outline.ijm` `EDF1\rpe_rsl3\script\export_fig.ijm` `EDF1\rpe_staurosporine\scriptexport_for_outline.ijm`| export microscopic images |
| 1b | `EDF1\sytox\script\summarize_tracking.m` | plot the nuclear dye and sytox dynamics |
| 1c | `EDF1\illustration\plot_examples.m` | plot contours, vector field and polar histogram to show how entropy is computed from a vector field |
| 1e, 1g, 1i to 1m | `EDF1\others\export_vector_field_polarhist.m` `EDF1\others\export_figure_entropy.m` | plot vector fields, polar histograms, and the summary of entropy |

### Extended data figure 2
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 2a | `EDF2\initiation_analysis\script\mark_initiation.m` | plot the initiation sites on an image |
| 2b | `EDF2\initiation_analysis\script\plot_initiation_heatmap.m` | plot the heatmap of number of initiations at each viewfield |
| 2c and 2d | `EDF2\initiation_analysis\script\initiation_Poisson_dist_fitting.m` `EDF2\initiation_analysis\script\initiation_Exp_dist_fitting.m`| plot the histogram and fitted logistic distribution for number of initiations and interval between initiations |
| 2e and 2f | `EDF2\distribution_iron_ros\distribution_iron.m` `EDF2\distribution_iron_ros\distribution_ros.m` | plot the histogram and fitted logistic distribution for iron and ROS |
| 2g and 2h | `EDF2\optimization\organize_measurement.m` | plot number and timing of initiation under different levels of FBS and transferrin |

### Extended data figure 3
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 3b | `EDF3\light_induction\script\export.ijm` | export microscopic image |
| 3c | `EDF3\h2o2_induction\script\export.ijm` `EDF3\h2o2_induction\script\outline_v2.m` | export microscopic image and plot outlines |
| 3d | `EDF3\death_inhibitors\script\export_images_around_induction.ijm` `EDF3\death_inhibitors\script\export_dfo_fer1_lip1.ijm` | export micrscopic images around induction |
| 3e to 3j | `EDF3\wavelength_exposure\export_images_around_induction.ijm` `EDF3\wavelength_exposure\summarize_intensity.m` `EDF3\wavelength_exposure\summarize_wavelength.m` | export micrscopic images around induction, plot ROS dynamics and speed measurement under different wavelength and exposure time of light |
| 3k and 3l | `EDF3\death_inhibitors\script\make_kymograph.m` `EDF3\death_inhibitors\script\plot_kymograph_fer1.m` `EDF3\death_inhibitors\script\summarize_speed.m` | plot kymograph and speed measurement under different death inhibitors |

### Extended data figure 4
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 4a | `EDF4\cellROX\script\export.ijm` `EDF4\cellROX\script\outline.m` `EDF4\cellROX\script\plot_profile.m` | export microscopic image, plot outlines, and plot profiles |
| 4d | `EDF4\cellROX\script\make_kymograph.m` | plot the kymograph |
| 4e | `EDF4\ros_scavengers\script\make_kymograph.m` | plot the kymographs |

### Extended data figure 5
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 5a | `EDF5\gap\script\export.ijm` `EDF5\gap\script\plot_profile.m` | export microscopic image and plot profiles |
| 5b and 5c | `EDF5\conditioned_media\script\export_fig.ijm` `EDF5\conditioned_media\script\quantify_death_percentage.m` | export microscopic image and plot death percentage |

### Extended data figure 6
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 6b | `EDF6\iron\make_kymograph.m` | plot the kymograph |
| 6c and 6d | `EDF6\a549_u2os\script\export_v2.ijm` `EDF6\a549_u2os\script\outline_a549.m` `EDF6\a549_u2os\script\outline_a549.m` | export microscopic image and plot outline |

### Extended data figure 7
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 7a | `EDF7\plot_NOX_isoform.m` | plot the mRNA abundance of NOX isoform |
| 7b | `EDF7\antioxidant.m` | plot the antiocidant activity |

### Extended data figure 8
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 8c | `EDF8\plot_NOX_activity.m` | plot the NOX activity |
| 8d and 8e | `EDF8\make_kymograph.m` | plot the kymographs |

### Extended data figure 9
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 9a | `EDF9\export_kymograph.m` | plot the kymographs |
| 9b | `EDF9\summarize_speed.m` | plot the measured speed |

### Extended data figure 10
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 10b and 10c | `EDF10\figS10bc.m` | plot the simulated wave in the view of 2D and cross-section |
| 10d and 10e | `EDF10\figS10de.m` | plot the measured speed, wavefront width, and amplitude |

### Extended data figure 11
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 11a | `EDF11\light_intensity\plot_result.m` | plot the ROS steady states |
| 11b to 11e | `EDF11\iron\plot_GSH.m` `EDF11\iron\quantify_iron.m` `EDF11\iron\plot_NOX_activity.m` `EDF11\iron\quantify_ros_before_photoinduction.m` `EDF11\iron\export_iron.ijm` | plot the measured GSH, iron, NOX activity, and ROS and export microscopic images |

### Extended data figure 12
| Figure  | Scripts | Description |
| :------------- | :------------- | :------------- |
| 12a | `EDF12\developing_limb_muscle\script\export_fig.ijm` `EDF12\developing_limb_muscle\outline.m`| export the microscopic image and plot outlines |
| 12b to 12e | `EDF12\coloc\script\export_12b.ijm` `EDF12\coloc\script\export_12c.ijm` `EDF12\coloc\script\export_12d.ijm` `EDF12\coloc\script\export_12e.ijm`| export the microscopic images |
| 12f to 12h | `EDF12\tunel_4hne\script\export_fig.ijm` `EDF12\tunel_4hne\script\plot_profile_4hne.m` `EDF12\tunel_4hne\script\plot_profile_tunel.m` `EDF12\tunel_4hne\script\plot_result.m`| export the microscopic image and plot profiles and measured intensity |
| 12i and 12j | `EDF12\fiber_quantification\plot_fiber_count.m` `EDF12\fiber_quantification\plot_entropy_histogram.m`| plot the measured fiber count ane entropy of fiber orientation |
