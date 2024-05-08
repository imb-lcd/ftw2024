After running `preprocess.ijm` to process the raw image
1. run `exprot_DFO.ijm` to export the image in figure 3c
2. run `generate_outline_DFO.m` to get the outline in figure 3c
3. run `exprot_FAC.ijm` to export the image in figure 3e
4. run `generate_outline_FAC.m.m` to get the outline in figure 3e
5. run `make_kymograph.m` to get the kymographs in figure 3d, 3f, 3g, 3h, and 3i (`mask_initiation.m`, `speed_estimation.m`, and `plotKymo.m` are called)
6. run `summarize_DFO_96.m` to fit the dose response curve and plot the figure 3j.
7. run `summarize_FAC_96.m` to fit the dose response curve and plot the figure 3k.
8. run `summarize_GKT_96.m` to fit the dose response curve and plot the figure 3l.
9. run `summarize_LY294002_96.m` to fit the dose response curve and plot the figure 3m.
10. run `summarize_Dasatinib_96.m` to fit the dose response curve and plot the figure 3n.