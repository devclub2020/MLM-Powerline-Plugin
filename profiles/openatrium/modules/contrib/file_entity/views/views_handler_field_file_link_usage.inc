<?php

/**
 * @file
 * Definition of views_handler_field_file_link_usage.
 */

/**
 * Field handler to present a link to view the usage of a file.
 *
 * @ingroup views_field_handlers
 */
class views_handler_field_file_link_usage extends views_handler_field_file_link {

  /**
   * Renders the link.
   */
  function render_link($file, $values) {
    // Ensure user has access to view this file.
    if (!file_entity_access('view', $file)) {
      return;
    }

    $this->options['alter']['make_link'] = TRUE;
    $this->options['alter']['path'] = "file/$file->fid/usage";
    $this->options['alter']['query'] = drupal_get_destination();

    $text = !empty($this->options['text']) ? $this->options['text'] : t('Usage');
    return $text;
  }
}
