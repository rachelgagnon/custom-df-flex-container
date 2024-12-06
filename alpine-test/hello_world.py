import apache_beam as beam

def main():
    with beam.Pipeline() as pipeline:
        (pipeline 
         | 'Create' >> beam.Create(['hello', 'world'])
         | 'Print' >> beam.Map(print))

if __name__ == '__main__':
    main()