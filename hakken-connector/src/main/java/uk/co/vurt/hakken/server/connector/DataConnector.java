package uk.co.vurt.hakken.server.connector;


import java.util.Date;
import java.util.List;

public interface DataConnector {


	public String getInstances(String username, Date lastUpdated);
	
	public List<DataConnectorTaskDefinition> getDefinitions();
	
	public DataConnectorTaskDefinition getDefinition(String name);
	
	public boolean createNew();
	
	public boolean save();
	
	public String getName();
	
	
	
//	public List<String> getPropertyNames();
	
	public String getInfo();
	
//	public void init(Properties properties);
	
	public List<String> getDataItems();
}
