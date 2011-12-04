require 'graphviz'

def init
  super
  sections.place(:state_machine_details).before(:children)
end

def state_machine_details
  @state_machines = object['state_machine_state_machines']

  return unless @state_machines

  @state_machine_image_objects = render_state_machine_data(@state_machines)

  erb(:state_machine_details)
end


def render_state_machine_data state_machines

  state_machine_image_paths = Hash.new

  images_base_path = File.dirname(serializer.serialized_path(object))

  state_machines.each do |state_machine_name, state_machine|

    image_file_name = object.name.to_s + '_' + state_machine_name + '.png'

    image_path = File.join(images_base_path, image_file_name)

    content = GraphViz.new(:G, :type => :digraph) do |graph|

      state_machine[:description][:events].each do |event_name, event|

        event[:description][:transitions].each do |transition|

          to_state = graph.add_node(transition[:to_state].to_s)

          transition[:from_states].each do |state|
            from_state = graph.add_node(state.to_s)
            link = graph.add_edge(from_state, to_state)
            link.label = event[:name].to_s
          end

        end

      end

    end.output(:png => String)

    serializer.serialize(image_path, content)

    state_machine_image_paths[state_machine_name] = image_path
  end

  return state_machine_image_paths

end
