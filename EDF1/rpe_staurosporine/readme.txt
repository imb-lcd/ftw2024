After running `preprocess.ijm` to process the raw images
1. run `export_for_outline.ijm` to get the images in the extended data figure 1h
2. run `outline.m` to get outline in the extended data figure 1h
3. run `vector_field.m`, `entropy.m`, and `entropy_rpe_staurosporine_center1.m` to get vector field and entropy (entropy_rpe_staurosporine_center1.mat)
4. the `colorcet.m` is used in `vector_field.m` to color the vectors at different time (the colorbar for vector in the figure)
