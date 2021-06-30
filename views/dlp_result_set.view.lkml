view: dlp_result_set {
    derived_table: {
      sql:
WITH dlp_scan_result as (
    SELECT
               row_number() OVER () as pk,
               info_type.name,
               likelihood,
               location.container.type as source_type,
               content_locations.container_name as source_location,
               content_locations.record_location.record_key.big_query_key.table_reference.project_id,
               content_locations.record_location.record_key.big_query_key.table_reference.dataset_id,
               content_locations.record_location.record_key.big_query_key.table_reference.table_id,
               content_locations.record_location.field_id.name as field_name,
               create_time.seconds,
               job_name,
              from `anand-bq-test-2.Anand_BQ_Test_1.dlp_scan_result_2`
              left join unnest(location.content_locations) content_locations
)

select dlp_scan_result.*, b.class
  from dlp_scan_result as dlp_scan_result
left join `anand-bq-test-2.Anand_BQ_Test_1.dlp_metadata` as b
  on dlp_scan_result.source_type = b.type
    and replace(dlp_scan_result.source_location,"gs://","") like concat(b.key, "%")
  where dlp_scan_result.source_type is not null
               ;;
    }

    dimension: pk {
      hidden: yes
      primary_key: yes
      type: number
      sql: ${TABLE}.pk ;;
    }

    dimension: name {
      label: "Rule Name"
      description: "DLP Rule Type Name"
      type: string
      sql: ${TABLE}.name ;;
    }

    dimension: likelihood {
      order_by_field: likelihood_order
      description: "Possible, Likely, Very Likely"
      type: string
      sql: ${TABLE}.likelihood ;;
    }

    dimension: likelihood_order {
      hidden: yes
      type: number
      sql: CASE WHEN ${likelihood} = "POSSIBLE" THEN 1
                WHEN ${likelihood} = "LIKELY" THEN 2
                WHEN ${likelihood} = "VERY LIKELY" THEN 3
                END;;
    }

    dimension: source_type {
      description: "BigQuery or GCP Bucket"
      type: string
      sql: ${TABLE}.source_type ;;
    }

    dimension: source_location {
      description: "Full path data source location"
      type: string
      sql: ${TABLE}.source_location ;;
    }

    dimension: project_id {
      group_label: "BigQuery Metadata"
      type: string
      sql: ${TABLE}.project_id ;;
    }

    dimension: dataset_id {
      group_label: "BigQuery Metadata"
      type: string
      sql: ${TABLE}.dataset_id ;;
    }

    dimension: table_id {
      group_label: "BigQuery Metadata"
      type: string
      sql: ${TABLE}.table_id ;;
    }

    dimension: field_name {
      group_label: "BigQuery Metadata"
      type: string
      sql: ${TABLE}.field_name ;;
    }

    dimension_group: run {
      timeframes: [raw,time,hour,date,week,month,quarter,year]
      type: time
      datatype: epoch
      sql: ${TABLE}.seconds ;;
    }

    dimension: job_name {
      description: "Name of the DLP Job"
      type: string
      sql: ${TABLE}.job_name ;;
    }

  dimension: class {
    description: "Metadata Class Type"
    type: string
    sql: ${TABLE}.class ;;
  }

    measure: count {
      label: "Count"
      type: count
    }


    set: detail {
      fields: [
        pk,
        name,
        likelihood,
        source_type,
        project_id,
        dataset_id,
        table_id,
        field_name,
        run_time,
        job_name
      ]
    }
  }
