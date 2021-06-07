view: dlp_result_set {
  derived_table: {
    sql: select
       row_number() OVER () as pk,
       info_type.name,
       likelihood,
       content_locations.container_name,
       content_locations.record_location.record_key.big_query_key.table_reference.project_id,
       content_locations.record_location.record_key.big_query_key.table_reference.dataset_id,
       content_locations.record_location.record_key.big_query_key.table_reference.table_id,
       content_locations.record_location.field_id.name,
       create_time.seconds
      from `anand-bq-test-2.Anand_BQ_Test_1.dlp_scan_result_2`
      left join unnest(location.content_locations) content_locations
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: pk {
    type: number
    sql: ${TABLE}.pk ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: likelihood {
    type: string
    sql: ${TABLE}.likelihood ;;
  }

  dimension: container_name {
    type: string
    sql: ${TABLE}.container_name ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: dataset_id {
    type: string
    sql: ${TABLE}.dataset_id ;;
  }

  dimension: table_id {
    type: string
    sql: ${TABLE}.table_id ;;
  }

  dimension: name_1 {
    type: string
    sql: ${TABLE}.name_1 ;;
  }

  dimension: seconds {
    type: number
    sql: ${TABLE}.seconds ;;
  }

  set: detail {
    fields: [
      pk,
      name,
      likelihood,
      container_name,
      project_id,
      dataset_id,
      table_id,
      name_1,
      seconds
    ]
  }
  }
