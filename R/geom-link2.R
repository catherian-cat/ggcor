#' Links layer
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_curve
#' @section Aesthetics:
#' \code{geom_links2()} understands the following aesthetics (required aesthetics are in bold):
#'     \itemize{
#'       \item \strong{\code{x}}
#'       \item \strong{\code{y}}
#'       \item \strong{\code{xend}}
#'       \item \strong{\code{yend}}
#'       \item \code{alpha}
#'       \item \code{colour}
#'       \item \code{fill}
#'       \item \code{group}
#'       \item \code{linetype}
#'       \item \code{size}
#'   }
#' @importFrom ggplot2 layer ggproto GeomCurve GeomPoint draw_key_path
#' @importFrom grid gTree
#' @rdname geom_links2
#' @author Houyun Huang, Lei Zhou, Jian Chen, Taiyun Wei
#' @export
geom_links2 <- function(mapping = NULL,
                        data = NULL,
                        stat = "identity",
                        position = "identity",
                        ...,
                        curvature = 0,
                        angle = 90,
                        ncp = 5,
                        arrow = NULL,
                        arrow.fill = NULL,
                        lineend = "butt",
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomLinks2,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      curvature = curvature,
      angle = angle,
      ncp = ncp,
      arrow = arrow,
      arrow.fill = arrow.fill,
      lineend = lineend,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_links2
#' @format NULL
#' @usage NULL
#' @export
GeomLinks2 <- ggproto(
  "GeomLinks2", GeomCurve,
  draw_panel = function(self, data, panel_params, coord, rm.dup = TRUE,
                        node.shape = 21, node.colour = "blue", node.fill = "red",
                        node.size = 2, curvature = 0, angle = 90, ncp = 5, arrow = NULL,
                        arrow.fill = NULL, lineend = "butt", na.rm = FALSE) {
    aesthetics <- setdiff(names(data), c("x", "y", "xend", "yend", "colour",
                                         "fill", "size", "linetype"))
    start.colour <- node.colour[1]
    end.colour <- if(length(node.colour) > 1) node.colour[2] else node.colour[1]
    start.fill <- node.fill[1]
    end.fill <- if(length(node.fill) > 1) node.fill[2] else node.fill[1]
    start.shape <- node.shape[1]
    end.shape <- if(length(node.shape) > 1) node.shape[2] else node.shape[1]
    start.size <- node.size[1]
    end.size <- if(length(node.size) > 1) node.size[2] else node.size[1]
    start.data <- new_data_frame(
      list(x = data$x,
           y = data$y,
           colour = start.colour,
           fill = start.fill,
           shape = start.shape,
           size = start.size,
           stroke = 0.5))
    end.data <- new_data_frame(
      list(x = data$xend,
           y = data$yend,
           colour = end.colour,
           fill = end.fill,
           shape = end.shape,
           size = end.size,
           stroke = 0.5))
    if(isTRUE(rm.dup)) {
      start.data <- cbind(start.data, data[aesthetics])[!duplicated(start.data), , drop = FALSE]
      end.data <- cbind(end.data, data[aesthetics])[!duplicated(end.data), , drop = FALSE]
    } else {
      start.data <- cbind(start.data, data[aesthetics])
      end.data <- cbind(end.data, data[aesthetics])
    }
    ggname(
      "geom_links2",
      grid::gTree(
        children = grid::gList(
          GeomCurve$draw_panel(data, panel_params, coord, curvature = curvature,
                               angle = angle, ncp = ncp, arrow = arrow,
                               arrow.fill = arrow.fill, lineend = lineend,
                               na.rm = na.rm),
          GeomPoint$draw_panel(start.data, panel_params, coord),
          GeomPoint$draw_panel(end.data, panel_params, coord)
        )
      )
    )
  },
  draw_key = draw_key_path
)
